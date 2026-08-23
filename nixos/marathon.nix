{
  flake.nixosModules.marathon = {pkgs, ...}: let
    checker = pkgs.writeTextFile {
      name = "poznan-marathon-check";
      executable = true;

      text = ''
        #!${pkgs.python3}/bin/python3

        import subprocess
        from html.parser import HTMLParser
        from urllib.request import Request, urlopen


        MARATHON_URL = "https://marathon.poznan.pl/"
        NTFY_URL = "https://ntfy.matmoa.eu/marathon"
        CAPACITY = 8000

        CHROMIUM = "${pkgs.chromium}/bin/chromium"


        class RunnerCountParser(HTMLParser):
            def __init__(self):
                super().__init__()
                self.in_target = False
                self.span_depth = 0
                self.parts = []
                self.count = None

            def handle_starttag(self, tag, attrs):
                if tag.lower() != "span":
                    return

                if self.in_target:
                    self.span_depth += 1
                    return

                classes = dict(attrs).get("class", "").split()

                if "uczestnicy-result" in classes:
                    self.in_target = True
                    self.span_depth = 1
                    self.parts = []

            def handle_data(self, data):
                if self.in_target:
                    self.parts.append(data)

            def handle_endtag(self, tag):
                if not self.in_target or tag.lower() != "span":
                    return

                self.span_depth -= 1

                if self.span_depth != 0:
                    return

                raw = "".join(self.parts)
                digits = "".join(c for c in raw if c.isdigit())

                if digits:
                    self.count = int(digits)

                self.in_target = False


        def get_rendered_html():
            result = subprocess.run(
                [
                    CHROMIUM,
                    "--headless=new",
                    "--no-sandbox",
                    "--disable-gpu",
                    "--disable-dev-shm-usage",
                    "--disable-extensions",
                    "--no-first-run",
                    "--no-default-browser-check",
                    "--user-data-dir=/tmp/poznan-marathon-chromium",
                    "--virtual-time-budget=10000",
                    "--dump-dom",
                    MARATHON_URL,
                ],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                timeout=75,
            )

            if result.returncode != 0:
                raise RuntimeError(
                    f"Chromium failed with exit code {result.returncode}:\n"
                    f"{result.stderr[-4000:]}"
                )

            if not result.stdout.strip():
                raise RuntimeError(
                    "Chromium returned an empty document"
                )

            return result.stdout


        def get_runner_count():
            html = get_rendered_html()

            parser = RunnerCountParser()
            parser.feed(html)

            if parser.count is None:
                marker = html.find("uczestnicy-result")

                if marker >= 0:
                    context = html[
                        max(0, marker - 300):
                        marker + 500
                    ]
                    raise RuntimeError(
                        "Found uczestnicy-result but no number.\n"
                        f"DOM context:\n{context}"
                    )

                raise RuntimeError(
                    "Could not find span.uczestnicy-result "
                    "in Chromium-rendered DOM"
                )

            return parser.count


        def notify(count):
            message = f"{count} / {CAPACITY} registered"

            request = Request(
                NTFY_URL,
                data=message.encode("utf-8"),
                method="POST",
                headers={
                    "Content-Type": "text/plain; charset=utf-8",
                    "Title": "Poznan Marathon",
                },
            )

            with urlopen(request, timeout=30) as response:
                response.read()

            print(message, flush=True)


        notify(get_runner_count())
      '';
    };
  in {
    systemd.services.poznan-marathon = {
      description = "Check Poznan Marathon registration count and notify ntfy";

      wants = ["network-online.target"];
      after = ["network-online.target"];

      environment = {
        HOME = "/tmp";
        SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
      };

      serviceConfig = {
        Type = "oneshot";
        ExecStart = checker;
        TimeoutStartSec = "2min";

        DynamicUser = true;
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
      };
    };

    systemd.timers.poznan-marathon = {
      description = "Check Poznan Marathon registrations every morning";

      wantedBy = ["timers.target"];

      timerConfig = {
        OnCalendar = "*-*-* 08:00:00 Europe/Warsaw";
        AccuracySec = "1s";
        Persistent = true;
        Unit = "poznan-marathon.service";
      };
    };
  };
}
