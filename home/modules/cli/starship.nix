{config, ...}: {
  programs.starship = with config.colorScheme.palette; {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = true;

      format = ''
        [ ](fg:#${base00} bg:#${orange})$username[ ](fg:#${orange} bg:#${base0E})$hostname[](fg:#${base0E} bg:#${base0B})$directory[](fg:#${base0B} bg:#${blue})$nix_shell[](fg:#${blue} bg:#${base0A})''${custom.microconda}[](fg:#${base0A} bg:#${base0E})''${custom.direnv}[](fg:#${base0E} bg:#${base00}ff)$git_branch$git_status$fill$time
        $character'';

      custom = {
        direnv = {
          format = "[  ]($style)";
          style = "fg:#${base00} bg:#${base0E}";
          when = "env | grep -E '^DIRENV_FILE='";
        };
        microconda = {
          when = ''test -n "$CONDA_PREFIX"'';
          format = "[ $symbol ]($style)";
          style = "fg:#${base00} bg:#${base0A}";
          symbol = "";
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
        format = "[$hostname ]($style)";
      };

      directory = {
        truncation_length = 6;
        truncate_to_repo = false;
        truncation_symbol = ".../";
        style = "bold fg:#${base00} bg:#${base0B}";
        format = "[ $path ]($style)";
      };

      git_branch = {
        style = "bold fg:#${base0E}";
        format = "[ $symbol$branch ]($style)";
      };

      git_status = {
        style = "bold fg:#${base0E}";
        format = "[$conflicted$ahead$behind$untracked$modified$staged$renamed$deleted]($style)";
        conflicted = "$count= ";
        ahead = "$count⇡ ";
        behind = "$count⇣ ";
        untracked = "$count? ";
        stashed = "$count$ ";
        modified = "$count! ";
        staged = "$count+ ";
        renamed = "$count» ";
        deleted = "$count✘ ";
      };

      fill = {
        symbol = " ";
        style = "bold #${base0B}";
      };

      nix_shell = {
        format = "[ 󱄅 ]($style)";
        style = "fg:#${base00} bg:#${blue}";
      };

      time = {
        disabled = false;
        time_format = "%X";
        style = "bold fg:#${orange}";
        format = "[ $time ]($style)";
      };

      character = {
        error_symbol = "[❯](bold #${base08})";
        success_symbol = "[❯](bold #${base0B})";
      };
    };
  };
}
