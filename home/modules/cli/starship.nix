{config, ...}: {
  programs.starship = with config.colorScheme.palette; {
    enable = true;
    settings = {
      add_newline = true;

      format = ''
        [ ](fg:#${base00} bg:#${orange})$username[ ](fg:#${orange} bg:#${base0E})$hostname[](fg:#${base0E} bg:#${base0B})$directory[](fg:#${base0B} bg:#${blue})$nix_shell[](fg:#${blue} bg:#${orange})''${custom.nix_ns}[ ](fg:#${orange} bg:#${base00}ff)'';

      custom = {
        nix_ns = {
          when = "env | grep -E '^NS_PACKAGES='";
          command = "echo $NS_PACKAGES";
          format = "[ 󱄅 $output ]($style)";
          style = "bold fg:#${base00} bg:#${orange}";
        };
      };

      username = {
        show_always = true;
        style_user = "bold fg:#${base00} bg:#${orange}";
        format = "[$user ]($style)";
      };

      hostname = {
        ssh_only = false;
        style = "bold fg:#${base00} bg:#${base0E}";
        format = "[$ssh_symbol$hostname ]($style)";
        ssh_symbol = " ";
      };

      directory = {
        truncation_length = 6;
        truncate_to_repo = false;
        truncation_symbol = ".../";
        style = "bold fg:#${base00} bg:#${base0B}";
        format = "[ $path ]($style)";
      };

      nix_shell = {
        format = "[  ]($style)";
        style = "fg:#${base00} bg:#${blue}";
      };
    };
  };
}
