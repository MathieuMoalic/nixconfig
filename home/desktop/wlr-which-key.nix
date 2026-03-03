{
  flake.homeModules.wlr-which-key = {
    pkgs,
    lib,
    osConfig ? {},
    ...
  }: let
    configFile =
      pkgs.writeText "config.yaml"
      (pkgs.lib.generators.toYAML {} {
        font = "JetBrainsMono Nerd Font 22";
        background = "#282a36";
        color = "#f8f8f2";
        border = "#bd93f9";
        separator = " ➜ ";
        border_width = 2;
        corner_r = 10;
        padding = 15;
        rows_per_column = 25;
        column_padding = 25;

        anchor = "center";
        inhibit_compositor_keyboard_shortcuts = true;

        # unused: b e f j k m n p q t u w y
        menu =
          [
            {
              key = "s";
              desc = "Sleep";
              cmd = "${pkgs.systemd}/bin/systemctl suspend";
            }

            {
              key = "r";
              desc = "Reboot";
              submenu = [
                {
                  key = "Return";
                  desc = "Are you sure?";
                  cmd = "${pkgs.systemd}/bin/systemctl reboot";
                }
              ];
            }

            {
              key = "o";
              desc = "Shutdown";
              submenu = [
                {
                  key = "Return";
                  desc = "Are you sure?";
                  cmd = "${pkgs.systemd}/bin/systemctl poweroff";
                }
              ];
            }

            {
              key = "h";
              desc = "Hibernate";
              cmd = "${pkgs.systemd}/bin/systemctl hibernate";
            }
            {
              key = "l";
              desc = "Lock";
              cmd = "${pkgs.lock}/bin/lock";
            }
          ]
          ++ lib.optional (osConfig.programs.steam.enable or false) {
            key = "z";
            desc = "Steam";
            cmd = "${pkgs.steam}/bin/steam";
          }
          ++ [
            {
              key = "c";
              desc = "VSCode";
              cmd = "${pkgs.vscode}/bin/code";
            }
            {
              key = "d";
              desc = "Deezer";
              cmd = "${pkgs.deezer-enhanced}/bin/deezer-enhanced";
            }

            {
              key = "i";
              desc = "Inkscape";
              cmd = "${pkgs.inkscape}/bin/inkscape";
            }
            {
              key = "g";
              desc = "GIMP";
              cmd = "${pkgs.gimp}/bin/gimp";
            }
            {
              key = "v";
              desc = "LibreOffice";
              cmd = "${pkgs.libreoffice}/bin/libreoffice";
            }
            {
              key = "a";
              desc = "Chromium";
              cmd = "${pkgs.chromium}/bin/chromium";
            }
          ];
      });
  in {
    xdg.configFile."wlr-which-key/config.yaml".source = configFile;
  };
}
