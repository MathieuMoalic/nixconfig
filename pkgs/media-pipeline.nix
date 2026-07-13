{
  flake.overlays.media-pipeline = final: _: let
    mkvtoolnixPackage = final.mkvtoolnix-cli or final.mkvtoolnix;

    mediaPipelineScript =
      final.writers.writePython3Bin "media-pipeline" {
        libraries = [];
        flakeIgnore = [
          "E203"
          "E501"
          "W503"
        ];
      } ''
        """
        media_pipeline.py

        Custom media-processing pipeline for a Jellyfin/Shield-style library.

        Default behavior:
        - Read video files from /media/tdarr/in
        - Mirror folder structure into /media/tdarr/out
        - Output MKV
        - Keep embedded subtitles for English, French, and Polish, in any format
        - Embed matching English, French, and Polish sidecar subtitles
        - Keep only one audio track per language
        - Convert selected audio tracks to stereo AAC
        - Remux files that are already HEVC or below the bitrate cutoff
        - Transcode high-bitrate non-HEVC files to HEVC using VAAPI or libx265
        - During scans, prioritize transcode candidates and higher-bitrate files

        Examples:
            Dry-run a single file:
                python3 media_pipeline.py --dry-run \
                    "/media/tdarr/in/Movie (2024)/Movie (2024).mkv"

            Process one file:
                python3 media_pipeline.py --overwrite \
                    "/media/tdarr/in/Movie (2024)/Movie (2024).mkv"

            Scan the whole source tree, prioritizing transcode candidates by bitrate:
                python3 media_pipeline.py --scan --dry-run
                python3 media_pipeline.py --scan

            Sort every scanned file by bitrate, regardless of codec:
                python3 media_pipeline.py --scan --scan-order bitrate

            Keep the old alphabetical scan order:
                python3 media_pipeline.py --scan --scan-order path

            Use higher-quality stereo audio:
                python3 media_pipeline.py --scan --audio-bitrate 256k

            For older Intel VAAPI drivers, such as Skylake:
                python3 media_pipeline.py --libva-driver-name i965 --overwrite \
                    "/media/tdarr/in/Movie (2024)/Movie (2024).mkv"

            By default the script uses software decode plus VAAPI encode. If you want to
            force VAAPI hardware decoding too, add --vaapi-decode. If VAAPI is unavailable
            on the host, use --video-encoder libx265.
        """

        from __future__ import annotations

        import argparse
        import json
        import os
        import re
        import shlex
        import shutil
        import subprocess
        import sys
        import tempfile
        from dataclasses import dataclass
        from pathlib import Path
        from typing import Iterable, Sequence


        VIDEO_EXTENSIONS = {
            ".mkv",
            ".mp4",
            ".m4v",
            ".mov",
            ".avi",
            ".webm",
            ".ts",
            ".m2ts",
            ".mpg",
            ".mpeg",
            ".vob",
        }

        SUBTITLE_EXTENSIONS = {
            ".srt",
            ".ass",
            ".ssa",
            ".sup",  # PGS/SUP sidecar subtitles.
        }

        LANGUAGE_MAP = {
            "en": "eng",
            "eng": "eng",
            "fr": "fra",
            "fre": "fra",
            "fra": "fra",
            "pl": "pol",
            "pol": "pol",
            "es": "spa",
            "spa": "spa",
            "de": "deu",
            "deu": "deu",
            "ger": "deu",
            "it": "ita",
            "ita": "ita",
            "ja": "jpn",
            "jp": "jpn",
            "jpn": "jpn",
            "ko": "kor",
            "kor": "kor",
            "pt": "por",
            "por": "por",
            "ru": "rus",
            "rus": "rus",
            "zh": "chi",
            "chi": "chi",
            "zho": "chi",
        }

        LANGUAGE_NAMES = {
            "eng": "English",
            "fra": "French",
            "pol": "Polish",
            "spa": "Spanish",
            "deu": "German",
            "ita": "Italian",
            "jpn": "Japanese",
            "kor": "Korean",
            "por": "Portuguese",
            "rus": "Russian",
            "chi": "Chinese",
            "und": "Undetermined",
        }

        DEFAULT_SUBTITLE_LANGUAGES = "eng,fra,pol"

        COMMENTARY_TITLE_MARKERS = {
            "commentary",
            "commentary track",
            "director commentary",
            "audio commentary",
        }

        DESCRIPTIVE_AUDIO_MARKERS = {
            "audio description",
            "descriptive audio",
            "description",
            "visually impaired",
            "visual impaired",
            "ad)",
            "(ad",
        }


        @dataclass(frozen=True)
        class AudioStream:
            index: int
            language: str
            codec: str
            channels: int
            bitrate_kbps: int
            title: str
            default: bool

            @property
            def display_language(self) -> str:
                return language_name(self.language)


        @dataclass(frozen=True)
        class SubtitleStream:
            index: int
            language: str
            codec: str
            title: str
            default: bool
            forced: bool
            hearing_impaired: bool

            @property
            def display_language(self) -> str:
                return language_name(self.language)


        @dataclass(frozen=True)
        class MediaInfo:
            path: Path
            video_codec: str
            total_bitrate_kbps: int
            video_bitrate_kbps: int
            duration_seconds: float | None
            audio_streams: tuple[AudioStream, ...]
            subtitle_streams: tuple[SubtitleStream, ...]

            @property
            def best_bitrate_kbps(self) -> int:
                return self.total_bitrate_kbps or self.video_bitrate_kbps


        @dataclass(frozen=True)
        class SubtitleSidecar:
            path: Path
            language: str
            title: str
            forced: bool
            default: bool = False


        @dataclass(frozen=True)
        class Decision:
            action: str  # "remux" or "transcode"
            reason: str


        class PipelineError(RuntimeError):
            pass


        def main(argv: Sequence[str]) -> int:
            args = parse_args(argv)

            source_root = Path(args.source_root).resolve()
            output_root = Path(args.output_root).resolve()
            cache_root = Path(args.cache_root).resolve()

            if not source_root.exists():
                print(f"Source root does not exist: {source_root}", file=sys.stderr)
                return 1

            if not args.dry_run:
                cache_root.mkdir(parents=True, exist_ok=True)
                output_root.mkdir(parents=True, exist_ok=True)

            probe_cache: dict[Path, MediaInfo] = {}
            files = collect_input_files(
                args,
                source_root,
                probe_cache=probe_cache,
            )
            if not files:
                print("No input files found.")
                return 0

            failures = 0
            for index, source_file in enumerate(files, start=1):
                print()
                print(f"=== [{index}/{len(files)}] {source_file} ===")

                try:
                    process_file(
                        source_file=source_file,
                        source_root=source_root,
                        output_root=output_root,
                        cache_root=cache_root,
                        args=args,
                        media_info=probe_cache.get(source_file.resolve()),
                    )
                except Exception as exc:  # noqa: BLE001 - keep processing remaining files.
                    failures += 1
                    print(f"ERROR: {source_file}: {exc}", file=sys.stderr)

                    if args.stop_on_error:
                        break

            if failures:
                print(f"Completed with {failures} failure(s).", file=sys.stderr)
                return 1

            print()
            print("Completed successfully.")
            return 0


        def parse_args(argv: Sequence[str]) -> argparse.Namespace:
            parser = argparse.ArgumentParser(
                description=(
                    "Transcode/remux media to MKV with optional HEVC VAAPI, "
                    "one stereo audio track per language, and filtered en/fr/pl subtitles."
                )
            )

            parser.add_argument(
                "paths",
                nargs="*",
                help="Input video files. Each path must be under --source-root.",
            )
            parser.add_argument(
                "--scan",
                action="store_true",
                help="Process all supported video files under --source-root.",
            )
            parser.add_argument("--source-root", default="/media/tdarr/in")
            parser.add_argument("--output-root", default="/media/tdarr/out")
            parser.add_argument("--cache-root", default="/media/tdarr/cache")
            parser.add_argument(
                "--cutoff-kbps",
                type=int,
                default=6000,
                help="Only non-HEVC files above this bitrate are transcoded.",
            )
            parser.add_argument(
                "--video-encoder",
                choices=("hevc_vaapi", "libx265"),
                default="hevc_vaapi",
                help=(
                    "Video encoder used for transcodes. Default: hevc_vaapi. "
                    "Use libx265 when VAAPI is unavailable."
                ),
            )
            parser.add_argument(
                "--qp",
                type=int,
                default=28,
                help="HEVC VAAPI QP value. Lower is larger/better; higher is smaller/worse.",
            )
            parser.add_argument(
                "--x265-crf",
                type=int,
                default=24,
                help="libx265 CRF value. Lower is larger/better; higher is smaller/worse.",
            )
            parser.add_argument(
                "--x265-preset",
                default="medium",
                help="libx265 preset. Examples: ultrafast, medium, slow. Default: medium.",
            )
            parser.add_argument(
                "--audio-codec",
                default="aac",
                help="Codec used for the selected stereo audio tracks. Default: aac.",
            )
            parser.add_argument(
                "--audio-bitrate",
                default="192k",
                help="Bitrate used for each selected stereo audio track. Default: 192k.",
            )
            parser.add_argument(
                "--audio-channels",
                type=int,
                default=2,
                help="Number of output audio channels. Default: 2.",
            )
            parser.add_argument(
                "--subtitle-languages",
                default=DEFAULT_SUBTITLE_LANGUAGES,
                help=(
                    "Comma-separated subtitle languages to keep from source streams and "
                    "sidecars. Default: eng,fra,pol."
                ),
            )
            parser.add_argument("--vaapi-device", default="/dev/dri/renderD128")
            parser.add_argument(
                "--vaapi-decode",
                action="store_true",
                help=(
                    "Also use VAAPI for decoding. Default is software decode plus VAAPI "
                    "encode, which avoids many VAAPI decoder initialization failures."
                ),
            )
            parser.add_argument(
                "--libva-driver-name",
                default=None,
                help="Optional VAAPI driver override, for example i965 or iHD.",
            )
            parser.add_argument(
                "--libva-drivers-path",
                default="/run/opengl-driver/lib/dri",
            )
            parser.add_argument(
                "--ffmpeg",
                default=shutil.which("ffmpeg") or "/run/current-system/sw/bin/ffmpeg",
            )
            parser.add_argument(
                "--ffprobe",
                default=shutil.which("ffprobe") or "/run/current-system/sw/bin/ffprobe",
            )
            parser.add_argument(
                "--mkvmerge",
                default=shutil.which("mkvmerge") or "/run/current-system/sw/bin/mkvmerge",
            )
            parser.add_argument(
                "--overwrite",
                action="store_true",
                help="Overwrite existing output files.",
            )
            parser.add_argument(
                "--dry-run",
                action="store_true",
                help="Print decisions and commands without writing files.",
            )
            parser.add_argument(
                "--stop-on-error",
                action="store_true",
                help="Stop at the first failed file.",
            )
            parser.add_argument(
                "--max-files",
                type=int,
                default=None,
                help="Limit how many files are processed when using --scan.",
            )
            parser.add_argument(
                "--scan-order",
                choices=("transcode", "bitrate", "path"),
                default="transcode",
                help=(
                    "Scan processing order. "
                    "'transcode' prioritizes non-HEVC files above the cutoff, "
                    "then sorts by bitrate. "
                    "'bitrate' sorts all files by bitrate. "
                    "'path' keeps alphabetical order. "
                    "Default: transcode."
                ),
            )
            parser.add_argument(
                "--include-existing",
                action="store_true",
                help="Do not skip files whose output already exists.",
            )

            args = parser.parse_args(argv)

            if args.audio_channels < 1:
                parser.error("--audio-channels must be at least 1.")

            if not args.scan and not args.paths:
                parser.error("Provide at least one input file, or use --scan.")

            return args


        def collect_input_files(
            args: argparse.Namespace,
            source_root: Path,
            *,
            probe_cache: dict[Path, MediaInfo],
        ) -> list[Path]:
            if args.scan:
                files = list(iter_video_files(source_root))

                if args.scan_order != "path":
                    files = prioritize_input_files(
                        files,
                        ffprobe=args.ffprobe,
                        cutoff_kbps=args.cutoff_kbps,
                        mode=args.scan_order,
                        probe_cache=probe_cache,
                    )
            else:
                files = [Path(path).expanduser().resolve() for path in args.paths]

            # Apply the limit after priority sorting so --max-files selects the
            # highest-priority candidates rather than the first alphabetical paths.
            if args.max_files is not None:
                files = files[: args.max_files]

            return files


        def prioritize_input_files(
            files: Sequence[Path],
            *,
            ffprobe: str,
            cutoff_kbps: int,
            mode: str,
            probe_cache: dict[Path, MediaInfo],
        ) -> list[Path]:
            ranked: list[tuple[Path, int, bool, bool, int]] = []

            print(f"Probing {len(files)} file(s) for priority ordering...")

            for original_index, path in enumerate(files):
                resolved_path = path.resolve()

                try:
                    media_info = ffprobe_media(resolved_path, ffprobe)
                    probe_cache[resolved_path] = media_info

                    bitrate = media_info.best_bitrate_kbps
                    bitrate_known = bitrate > 0
                    needs_transcode = (
                        decide(media_info, cutoff_kbps).action == "transcode"
                    )
                except Exception as exc:  # noqa: BLE001 - rank remaining files too.
                    print(
                        f"WARNING: could not probe {resolved_path}: {exc}",
                        file=sys.stderr,
                    )
                    bitrate = 0
                    bitrate_known = False
                    needs_transcode = False

                ranked.append(
                    (
                        resolved_path,
                        original_index,
                        needs_transcode,
                        bitrate_known,
                        bitrate,
                    )
                )

            if mode == "transcode":
                ranked.sort(
                    key=lambda item: (
                        not item[2],  # Transcode candidates first.
                        not item[3],  # Known bitrates before unknown.
                        -item[4],     # Highest bitrate first.
                        item[1],      # Alphabetical input order as tie-breaker.
                    )
                )
            elif mode == "bitrate":
                ranked.sort(
                    key=lambda item: (
                        not item[3],
                        -item[4],
                        item[1],
                    )
                )
            else:
                raise PipelineError(f"Unsupported scan order: {mode}")

            return [item[0] for item in ranked]


        def iter_video_files(source_root: Path) -> Iterable[Path]:
            for path in sorted(source_root.rglob("*"), key=lambda item: str(item).lower()):
                if path.is_file() and path.suffix.lower() in VIDEO_EXTENSIONS:
                    yield path


        def process_file(
            *,
            source_file: Path,
            source_root: Path,
            output_root: Path,
            cache_root: Path,
            args: argparse.Namespace,
            media_info: MediaInfo | None = None,
        ) -> None:
            source_file = source_file.resolve()
            ensure_under_root(source_file, source_root)

            output_file = get_output_path(source_file, source_root, output_root)
            if output_file.exists() and not args.overwrite and not args.include_existing:
                print(f"Skipping because output already exists: {output_file}")
                return

            media_info = media_info or ffprobe_media(source_file, args.ffprobe)
            decision = decide(media_info, args.cutoff_kbps)
            selected_audio_streams = select_audio_streams(
                media_info.audio_streams,
                target_channels=args.audio_channels,
            )
            allowed_subtitle_languages = parse_language_list(args.subtitle_languages)
            selected_subtitle_streams = select_subtitle_streams(
                media_info.subtitle_streams,
                allowed_languages=allowed_subtitle_languages,
            )
            sidecars = find_sidecar_subtitles(
                source_file,
                allowed_languages=allowed_subtitle_languages,
            )

            print(f"Source: {source_file}")
            print(f"Output: {output_file}")
            print(f"Codec: {media_info.video_codec}")
            print(f"Bitrate: {media_info.best_bitrate_kbps} kbps")
            print(f"Decision: {decision.action} ({decision.reason})")
            if decision.action == "transcode":
                print(f"Video encoder: {args.video_encoder}")
            print(
                "Audio: "
                f"{len(media_info.audio_streams)} input track(s), "
                f"{len(selected_audio_streams)} selected "
                f"({args.audio_codec}, {args.audio_channels}ch, {args.audio_bitrate})"
            )

            for stream in selected_audio_streams:
                action = (
                    "downmix"
                    if stream.channels > args.audio_channels
                    else "encode"
                    if stream.channels == args.audio_channels
                    else "upmix"
                )
                print(
                    " - "
                    f"#{stream.index} [{stream.language}] "
                    f"{stream.codec}, {stream.channels or '?'}ch, "
                    f"{stream.bitrate_kbps or '?'} kbps"
                    f"{format_title(stream.title)} -> {action} to "
                    f"{args.audio_channels}ch {args.audio_codec} {args.audio_bitrate}"
                )

            skipped_audio_streams = [
                stream
                for stream in media_info.audio_streams
                if stream.index not in {selected.index for selected in selected_audio_streams}
            ]
            for stream in skipped_audio_streams:
                print(
                    " - skip "
                    f"#{stream.index} [{stream.language}] "
                    f"{stream.codec}, {stream.channels or '?'}ch"
                    f"{format_title(stream.title)}"
                )

            print(
                "Embedded subtitles: "
                f"{len(media_info.subtitle_streams)} input track(s), "
                f"{len(selected_subtitle_streams)} selected "
                f"({format_language_set(allowed_subtitle_languages)})"
            )
            for subtitle in selected_subtitle_streams:
                flags = []
                if subtitle.default:
                    flags.append("default")
                if subtitle.forced:
                    flags.append("forced")
                if subtitle.hearing_impaired:
                    flags.append("HI")
                flag_text = f" ({', '.join(flags)})" if flags else ""
                print(
                    " - "
                    f"#{subtitle.index} [{subtitle.language}] "
                    f"{subtitle.codec}{format_title(subtitle.title)}{flag_text}"
                )

            skipped_subtitle_streams = [
                stream
                for stream in media_info.subtitle_streams
                if stream.index
                not in {selected.index for selected in selected_subtitle_streams}
            ]
            for subtitle in skipped_subtitle_streams:
                print(
                    " - skip "
                    f"#{subtitle.index} [{subtitle.language}] "
                    f"{subtitle.codec}{format_title(subtitle.title)}"
                )

            print(f"Sidecars: {len(sidecars)}")
            for subtitle in sidecars:
                print(f" - {subtitle.path.name} [{subtitle.language}] {subtitle.title}")

            if args.dry_run:
                print("Dry-run: no files written.")
                return

            with tempfile.TemporaryDirectory(prefix="media-pipeline-", dir=cache_root) as tmp:
                tmp_dir = Path(tmp)
                prepared_file = tmp_dir / "prepared.mkv"
                final_tmp_file = tmp_dir / "final.mkv"

                prepare_video_and_audio(
                    source_file=source_file,
                    output_file=prepared_file,
                    decision=decision,
                    selected_audio_streams=selected_audio_streams,
                    selected_subtitle_streams=selected_subtitle_streams,
                    args=args,
                )

                mux_to_mkv_with_sidecars(
                    working_file=prepared_file,
                    original_file=source_file,
                    output_file=final_tmp_file,
                    sidecars=sidecars,
                    mkvmerge=args.mkvmerge,
                    dry_run=args.dry_run,
                )

                verify_output(final_tmp_file, args.ffprobe)

                output_file.parent.mkdir(parents=True, exist_ok=True)
                if output_file.exists():
                    output_file.unlink()

                shutil.move(str(final_tmp_file), str(output_file))
                print(f"Created: {output_file}")


        def ensure_under_root(path: Path, root: Path) -> None:
            try:
                path.relative_to(root)
            except ValueError as exc:
                raise PipelineError(
                    f"Input file is not under source root {root}: {path}"
                ) from exc


        MOVIE_ID_NAME_RE = re.compile(
            r"^(?P<title>.+?\(\d{4}\))\s*(?P<provider_id>\[(?:tmdbid|imdbid|tvdbid)-[^\]]+\])",
            re.IGNORECASE,
        )

        MOVIE_TITLE_YEAR_RE = re.compile(r"^(?P<title>.+?\(\d{4}\))")


        def get_output_path(source_file: Path, source_root: Path, output_root: Path) -> Path:
            relative_path = source_file.relative_to(source_root)
            clean_name = clean_movie_name(source_file) or clean_movie_name(source_file.parent)

            if clean_name:
                # Keep any grouping above the movie folder, but replace the movie folder
                # and output filename with a clean Jellyfin-friendly movie name.
                prefix = relative_path.parent.parent

                if str(prefix) == ".":
                    return output_root / clean_name / f"{clean_name}.mkv"

                return output_root / prefix / clean_name / f"{clean_name}.mkv"

            return output_root / relative_path.with_suffix(".mkv")


        def clean_movie_name(path: Path) -> str | None:
            name = path.stem if path.suffix.lower() in VIDEO_EXTENSIONS else path.name

            match = MOVIE_ID_NAME_RE.match(name)
            if match:
                return normalize_spaces(f"{match.group('title')} {match.group('provider_id')}")

            match = MOVIE_TITLE_YEAR_RE.match(name)
            if match:
                return normalize_spaces(match.group("title"))

            return None


        def normalize_spaces(value: str) -> str:
            return " ".join(value.split())


        def ffprobe_media(path: Path, ffprobe: str) -> MediaInfo:
            data = capture_json(
                [
                    ffprobe,
                    "-v",
                    "error",
                    "-analyzeduration",
                    "200M",
                    "-probesize",
                    "200M",
                    "-show_entries",
                    (
                        "format=bit_rate,duration:"
                        "stream=index,codec_type,codec_name,bit_rate,channels,channel_layout:"
                        "stream_tags=language,title:"
                        "stream_disposition=default,forced,hearing_impaired"
                    ),
                    "-of",
                    "json",
                    str(path),
                ]
            )

            streams = data.get("streams", [])
            video_stream = next(
                (stream for stream in streams if stream.get("codec_type") == "video"),
                None,
            )

            if not video_stream:
                raise PipelineError(f"No video stream found: {path}")

            format_data = data.get("format", {})
            total_bitrate_bps = to_int(format_data.get("bit_rate"))
            video_bitrate_bps = to_int(video_stream.get("bit_rate"))

            return MediaInfo(
                path=path,
                video_codec=str(video_stream.get("codec_name", "")).lower(),
                total_bitrate_kbps=round(total_bitrate_bps / 1000) if total_bitrate_bps else 0,
                video_bitrate_kbps=round(video_bitrate_bps / 1000) if video_bitrate_bps else 0,
                duration_seconds=to_float_or_none(format_data.get("duration")),
                audio_streams=tuple(parse_audio_streams(streams)),
                subtitle_streams=tuple(parse_subtitle_streams(streams)),
            )


        def parse_audio_streams(streams: Sequence[dict]) -> list[AudioStream]:
            audio_streams: list[AudioStream] = []

            for stream in streams:
                if stream.get("codec_type") != "audio":
                    continue

                tags = stream.get("tags") or {}
                disposition = stream.get("disposition") or {}
                bit_rate_bps = to_int(stream.get("bit_rate"))

                audio_streams.append(
                    AudioStream(
                        index=to_int(stream.get("index")),
                        language=normalize_language(tags.get("language")),
                        codec=str(stream.get("codec_name", "")).lower(),
                        channels=to_int(stream.get("channels")),
                        bitrate_kbps=round(bit_rate_bps / 1000) if bit_rate_bps else 0,
                        title=str(tags.get("title", "")),
                        default=bool(to_int(disposition.get("default"))),
                    )
                )

            return audio_streams


        def parse_subtitle_streams(streams: Sequence[dict]) -> list[SubtitleStream]:
            subtitle_streams: list[SubtitleStream] = []

            for stream in streams:
                if stream.get("codec_type") != "subtitle":
                    continue

                tags = stream.get("tags") or {}
                disposition = stream.get("disposition") or {}

                subtitle_streams.append(
                    SubtitleStream(
                        index=to_int(stream.get("index")),
                        language=subtitle_language(tags),
                        codec=str(stream.get("codec_name", "")).lower(),
                        title=str(tags.get("title", "")),
                        default=bool(to_int(disposition.get("default"))),
                        forced=bool(to_int(disposition.get("forced"))),
                        hearing_impaired=bool(to_int(disposition.get("hearing_impaired"))),
                    )
                )

            return subtitle_streams


        def decide(media_info: MediaInfo, cutoff_kbps: int) -> Decision:
            if media_info.video_codec == "hevc":
                return Decision("remux", "already HEVC")

            bitrate = media_info.best_bitrate_kbps
            if bitrate == 0:
                return Decision("transcode", "bitrate unknown and codec is not HEVC")

            if bitrate <= cutoff_kbps:
                return Decision("remux", f"{bitrate} kbps <= cutoff {cutoff_kbps} kbps")

            return Decision("transcode", f"{bitrate} kbps > cutoff {cutoff_kbps} kbps")


        def select_audio_streams(
            audio_streams: Sequence[AudioStream],
            *,
            target_channels: int,
        ) -> list[AudioStream]:
            selected: list[AudioStream] = []

            for language in sorted({stream.language for stream in audio_streams}):
                candidates = [stream for stream in audio_streams if stream.language == language]
                selected.append(
                    min(
                        candidates,
                        key=lambda stream: audio_preference_key(
                            stream,
                            target_channels=target_channels,
                        ),
                    )
                )

            return selected


        def select_subtitle_streams(
            subtitle_streams: Sequence[SubtitleStream],
            *,
            allowed_languages: set[str],
        ) -> list[SubtitleStream]:
            return [
                stream for stream in subtitle_streams if stream.language in allowed_languages
            ]


        def audio_preference_key(
            stream: AudioStream,
            *,
            target_channels: int,
        ) -> tuple[int, int, int, int, int, int]:
            """
            Lower is better.

            Preference order:
            1. Avoid commentary/descriptive tracks.
            2. Prefer tracks that are already the target channel count.
            3. Prefer the source default track among otherwise equivalent tracks.
            4. Prefer richer sources only when downmixing is required.
            5. Prefer higher bitrate among otherwise equivalent tracks.
            6. Prefer earlier input stream order as a final tie-breaker.
            """

            unwanted_track_penalty = 1 if is_unwanted_audio_track(stream.title) else 0

            if stream.channels == target_channels:
                channel_penalty = 0
                channel_richness = 0
            elif stream.channels > target_channels:
                channel_penalty = 1
                channel_richness = -stream.channels
            elif stream.channels > 0:
                channel_penalty = 2
                channel_richness = -stream.channels
            else:
                channel_penalty = 3
                channel_richness = 0

            default_penalty = 0 if stream.default else 1

            return (
                unwanted_track_penalty,
                channel_penalty,
                default_penalty,
                channel_richness,
                -stream.bitrate_kbps,
                stream.index,
            )


        def is_unwanted_audio_track(title: str) -> bool:
            normalized_title = title.lower()
            return any(
                marker in normalized_title for marker in COMMENTARY_TITLE_MARKERS
            ) or any(marker in normalized_title for marker in DESCRIPTIVE_AUDIO_MARKERS)


        def prepare_video_and_audio(
            *,
            source_file: Path,
            output_file: Path,
            decision: Decision,
            selected_audio_streams: Sequence[AudioStream],
            selected_subtitle_streams: Sequence[SubtitleStream],
            args: argparse.Namespace,
        ) -> None:
            output_file.parent.mkdir(parents=True, exist_ok=True)

            env = os.environ.copy()
            command = [args.ffmpeg, "-hide_banner", "-y"]

            if decision.action == "transcode" and args.video_encoder == "hevc_vaapi":
                env["LIBVA_DRIVERS_PATH"] = args.libva_drivers_path
                if args.libva_driver_name:
                    env["LIBVA_DRIVER_NAME"] = args.libva_driver_name

                if args.vaapi_decode:
                    command.extend(
                        [
                            "-hwaccel",
                            "vaapi",
                            "-hwaccel_device",
                            args.vaapi_device,
                            "-hwaccel_output_format",
                            "vaapi",
                        ]
                    )
                else:
                    command.extend(["-vaapi_device", args.vaapi_device])

            command.extend(
                [
                    "-analyzeduration",
                    "200M",
                    "-probesize",
                    "200M",
                    "-i",
                    str(source_file),
                ]
            )

            # Keep only the primary video stream, one selected audio stream per language,
            # and all source subtitle streams in the allowed subtitle languages.
            command.extend(["-map", "0:v:0"])
            for stream in selected_audio_streams:
                command.extend(["-map", f"0:{stream.index}"])
            for stream in selected_subtitle_streams:
                command.extend(["-map", f"0:{stream.index}"])

            command.extend(["-map_metadata", "0", "-map_chapters", "0"])

            if decision.action == "transcode":
                if args.video_encoder == "hevc_vaapi":
                    video_filter = (
                        "scale_vaapi=format=nv12"
                        if args.vaapi_decode
                        else "format=nv12,hwupload"
                    )
                    command.extend(
                        [
                            "-c:v",
                            "hevc_vaapi",
                            "-vf",
                            video_filter,
                            "-qp",
                            str(args.qp),
                        ]
                    )
                elif args.video_encoder == "libx265":
                    command.extend(
                        [
                            "-c:v",
                            "libx265",
                            "-preset",
                            args.x265_preset,
                            "-crf",
                            str(args.x265_crf),
                            "-pix_fmt",
                            "yuv420p",
                        ]
                    )
                else:
                    raise PipelineError(f"Unsupported video encoder: {args.video_encoder}")
            else:
                command.extend(["-c:v", "copy"])

            if selected_audio_streams:
                command.extend(
                    [
                        "-c:a",
                        args.audio_codec,
                        "-b:a",
                        args.audio_bitrate,
                        "-ac:a",
                        str(args.audio_channels),
                    ]
                )

                default_audio_index = get_default_output_audio_index(selected_audio_streams)
                for output_index, stream in enumerate(selected_audio_streams):
                    command.extend(
                        [
                            f"-metadata:s:a:{output_index}",
                            f"language={stream.language}",
                            f"-metadata:s:a:{output_index}",
                            f"title={audio_output_title(stream, args.audio_channels)}",
                            f"-disposition:a:{output_index}",
                            "default" if output_index == default_audio_index else "0",
                        ]
                    )

            if selected_subtitle_streams:
                command.extend(["-c:s", "copy"])

                for output_index, stream in enumerate(selected_subtitle_streams):
                    command.extend(
                        [
                            f"-metadata:s:s:{output_index}",
                            f"language={stream.language}",
                        ]
                    )

                    if stream.title:
                        command.extend(
                            [
                                f"-metadata:s:s:{output_index}",
                                f"title={stream.title}",
                            ]
                        )

                    command.extend(
                        [
                            f"-disposition:s:{output_index}",
                            subtitle_disposition_value(stream),
                        ]
                    )

            command.extend(["-max_muxing_queue_size", "9999", str(output_file)])

            run_command(command, env=env, dry_run=args.dry_run)


        def get_default_output_audio_index(audio_streams: Sequence[AudioStream]) -> int:
            for output_index, stream in enumerate(audio_streams):
                if stream.default:
                    return output_index

            return 0


        def audio_output_title(stream: AudioStream, target_channels: int) -> str:
            base = f"{stream.display_language} Stereo"
            if stream.channels > target_channels:
                return f"{base} Downmix"

            return base


        def subtitle_disposition_value(stream: SubtitleStream) -> str:
            dispositions: list[str] = []

            if stream.default:
                dispositions.append("default")
            if stream.forced:
                dispositions.append("forced")
            if stream.hearing_impaired:
                dispositions.append("hearing_impaired")

            return "+".join(dispositions) if dispositions else "0"


        def mux_to_mkv_with_sidecars(
            *,
            working_file: Path,
            original_file: Path,
            output_file: Path,
            sidecars: Sequence[SubtitleSidecar],
            mkvmerge: str,
            dry_run: bool,
        ) -> None:
            output_file.parent.mkdir(parents=True, exist_ok=True)

            command = [
                mkvmerge,
                "-o",
                str(output_file),
                str(working_file),
            ]

            for sidecar in sidecars:
                command.extend(["--language", f"0:{sidecar.language}"])
                command.extend(["--track-name", f"0:{sidecar.title}"])
                command.extend(["--default-track", "0:yes" if sidecar.default else "0:no"])
                command.extend(["--forced-display-flag", "0:yes" if sidecar.forced else "0:no"])
                command.append(str(sidecar.path))

            print(f"Embedding subtitles from: {original_file.parent}")
            run_command(command, dry_run=dry_run)


        def find_sidecar_subtitles(
            video_file: Path,
            *,
            allowed_languages: set[str],
        ) -> list[SubtitleSidecar]:
            stem = video_file.stem
            directory = video_file.parent
            sidecars: list[SubtitleSidecar] = []

            for candidate in sorted(directory.iterdir(), key=lambda item: item.name.lower()):
                if not candidate.is_file():
                    continue

                if candidate.suffix.lower() not in SUBTITLE_EXTENSIONS:
                    continue

                if not candidate.name.startswith(f"{stem}."):
                    continue

                suffix = candidate.name[len(stem) + 1 : -len(candidate.suffix)]
                sidecar = parse_subtitle_sidecar(candidate, suffix)
                if sidecar.language not in allowed_languages:
                    continue

                sidecars.append(sidecar)

            return sidecars


        def parse_subtitle_sidecar(path: Path, suffix: str) -> SubtitleSidecar:
            parts = [part.lower() for part in suffix.split(".") if part]
            first = parts[0] if parts else ""
            language = normalize_language(first)
            title_base = language_name(language) if language != "und" else suffix or "Subtitle"

            flags: list[str] = []
            if "hi" in parts or "sdh" in parts:
                flags.append("HI")
            if "forced" in parts:
                flags.append("Forced")

            title = f"{title_base} {' '.join(flags)}".strip()

            return SubtitleSidecar(
                path=path,
                language=language,
                title=title,
                forced="forced" in parts,
            )


        def verify_output(path: Path, ffprobe: str) -> None:
            if not path.exists():
                raise PipelineError(f"Output was not created: {path}")

            media_info = ffprobe_media(path, ffprobe)
            print(
                "Verified: "
                f"codec={media_info.video_codec}, "
                f"bitrate={media_info.best_bitrate_kbps} kbps, "
                f"audio_tracks={len(media_info.audio_streams)}"
            )


        def run_command(
            command: Sequence[str],
            *,
            dry_run: bool,
            env: dict[str, str] | None = None,
        ) -> None:
            print("+ " + shlex.join(command))

            if dry_run:
                return

            process = subprocess.run(command, env=env, check=False)
            if process.returncode != 0:
                raise PipelineError(
                    f"Command failed with exit code {process.returncode}: {shlex.join(command)}"
                )


        def capture_json(command: Sequence[str]) -> dict:
            process = subprocess.run(
                command,
                check=False,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
            )

            if process.returncode != 0:
                raise PipelineError(
                    f"Command failed:\n+ {shlex.join(command)}\n{process.stderr}"
                )

            try:
                return json.loads(process.stdout)
            except json.JSONDecodeError as exc:
                raise PipelineError(
                    f"Invalid JSON from command: {shlex.join(command)}"
                ) from exc


        def parse_language_list(value: str) -> set[str]:
            languages = {normalize_language(item) for item in value.split(",") if item.strip()}
            languages.discard("und")

            if not languages:
                raise PipelineError("No valid subtitle languages were configured.")

            return languages


        def subtitle_language(tags: dict) -> str:
            language = normalize_language(tags.get("language"))
            if language != "und":
                return language

            title = str(tags.get("title", "")).lower()
            padded_title = f" {title} "
            if "english" in title or " eng " in padded_title or "en-" in title:
                return "eng"
            if "french" in title or "français" in title or "francais" in title:
                return "fra"
            if "polish" in title or "polski" in title:
                return "pol"

            return "und"


        def format_language_set(languages: set[str]) -> str:
            return ", ".join(language_name(language) for language in sorted(languages))


        def normalize_language(value: object) -> str:
            language = str(value or "").strip().lower()
            if not language:
                return "und"

            if language in LANGUAGE_MAP:
                return LANGUAGE_MAP[language]

            if len(language) == 3:
                return language

            return "und"


        def language_name(language: str) -> str:
            return LANGUAGE_NAMES.get(
                language, language.upper() if language else "Undetermined"
            )


        def format_title(title: str) -> str:
            return f", title={title!r}" if title else ""


        def to_int(value: object) -> int:
            try:
                return int(str(value))
            except (TypeError, ValueError):
                return 0


        def to_float_or_none(value: object) -> float | None:
            try:
                return float(str(value))
            except (TypeError, ValueError):
                return None


        if __name__ == "__main__":
            raise SystemExit(main(sys.argv[1:]))
      '';
  in {
    media-pipeline = final.symlinkJoin {
      name = "media-pipeline";
      paths = [mediaPipelineScript];
      nativeBuildInputs = [final.makeWrapper];

      postBuild = ''
        wrapProgram "$out/bin/media-pipeline" \
          --prefix PATH : ${final.lib.makeBinPath [
          final.ffmpeg
          mkvtoolnixPackage
        ]}
      '';

      meta = with final.lib; {
        description = "Jellyfin/Tdarr media processing pipeline";
        mainProgram = "media-pipeline";
        platforms = platforms.linux;
      };
    };
  };
}
