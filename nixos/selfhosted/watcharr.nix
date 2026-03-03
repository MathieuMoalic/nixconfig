{...}: {
  flake.nixosModules.watcharr = {
    lib,
    config,
    pkgs,
    ...
  }: let
    port = 3080; # this is hardcoded in watcharr ...
    user = "watcharr";
    group = "media";
    url = "watcharr.matmoa.eu";
    dataDir = "/var/lib/watcharr";

    src = pkgs.fetchFromGitHub {
      owner = "sbondCo";
      repo = "Watcharr";
      rev = "v2.1.1";
      hash = "sha256-vuqymvPxQwWgmNvr6wNk5P2TFyCYkj0K5ncb3Q1eRbs=";
    };

    ui = pkgs.buildNpmPackage {
      pname = "watcharr-ui";
      version = "2.1.1";
      inherit src;
      nodejs = pkgs.nodejs_20;
      npmDepsHash = "sha256-vUbkTUaDQbvfc439ufLVGUR0Z/l3LlLE72fcc7m1o50=";
      installPhase = ''
        runHook preInstall
        mkdir -p $out
        cp -r build $out/
        runHook postInstall
      '';
    };

    package = pkgs.buildGoModule {
      pname = "watcharr";
      version = "2.1.1";
      inherit src;
      modRoot = "server";
      subPackages = ["."];
      vendorHash = "sha256-DaKPl0Th85WOXfAactTSYNOmQcz9Yh0mydTCVkMkbQA=";
      env.CGO_ENABLED = 1;
      env.CGO_CFLAGS = "-D_LARGEFILE64_SOURCE";
      nativeBuildInputs = [pkgs.pkg-config];
      buildInputs = [pkgs.sqlite];
      preBuild = ''
        mkdir -p ui
        cp -r ${ui}/build/. ui/
      '';
      postInstall = ''
        mkdir -p "$out/ui"
        cp -r ${ui}/build/. "$out/ui/"
      '';
      meta = with lib; {
        description = "Self-hostable watched list (movies, TV, anime, games)";
        homepage = "https://watcharr.app";
        license = licenses.mit;
        platforms = platforms.linux;
        mainProgram = "server";
      };
    };
  in {
    # Ensure service user/group exist
    users.groups.${group} = {};
    users.users.${user} = {
      isSystemUser = true;
      group = group;
    };

    # Ensure data dir exists with the right perms
    systemd.tmpfiles.rules = [
      "d ${dataDir} 0750 ${user} ${group} - -"
    ];

    systemd.services.watcharr = {
      description = "Watcharr server";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      wantedBy = ["multi-user.target"];

      environment = {
        WATCHARR_DATA = toString dataDir;
      };
      path = [pkgs.nodejs_20];

      serviceConfig = {
        Type = "simple";
        User = user;
        Group = group;

        # Run inside the store path so relative "./ui" resolves
        WorkingDirectory = package;

        # Prefer $out/bin/watcharr; fall back to $out/bin/server if needed
        ExecStart = "${package}/bin/Watcharr";

        Restart = "on-failure";
        RestartSec = "2s";

        # Hardening (unchanged)
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;

        # Allow writes only to the data dir
        ReadWritePaths = [dataDir];
      };
    };
    services.caddy.virtualHosts.${url}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
