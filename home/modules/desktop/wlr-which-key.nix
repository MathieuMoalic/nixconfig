{pkgs, ...}: let
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

      menu = [
        {
          key = "s";
          desc = "Sleep";
          cmd = "systemctl suspend";
        }

        {
          key = "r";
          desc = "Reboot";
          submenu = [
            {
              key = "Return";
              desc = "Are you sure?";
              cmd = "reboot";
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
              cmd = "poweroff";
            }
          ];
        }

        {
          key = "h";
          desc = "Hibernate";
          cmd = "systemctl hibernate";
        }
        {
          key = "l";
          desc = "Lock";
          cmd = "lock";
        }

        {
          key = "z";
          desc = "Steam";
          cmd = "steam";
        }
        {
          key = "x";
          desc = "Lutris";
          cmd = "lutris";
        }
        {
          key = "c";
          desc = "VSCode";
          cmd = "code";
        }
        {
          key = "d";
          desc = "Deezer";
          cmd = "deezer-enhanced";
        }

        {
          key = "i";
          desc = "Inkscape";
          cmd = "inkscape";
        }
        {
          key = "g";
          desc = "GIMP";
          cmd = "gimp";
        }
        {
          key = "v";
          desc = "LibreOffice";
          cmd = "libreoffice";
        }
        {
          key = "a";
          desc = "Anki";
          cmd = "anki";
        }
      ];
    });
in {
  xdg.configFile."wlr-which-key/config.yaml".source = configFile;
}
