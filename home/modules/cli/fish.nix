{...}: {
  programs = {
    fish = {
      enable = true;
      shellInit = ''
        set -g fish_greeting ""
        bind \cl 'commandline -r "l"; commandline -f execute'
        bind \ck 'clear; commandline -f repaint'
      '';
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    skim = {
      enable = true;
      enableFishIntegration = true;
    };

    carapace = {
      enable = true;
      enableFishIntegration = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };

    thefuck = {
      enable = true;
      enableFishIntegration = true;
    };

    eza = {
      enable = true;
      enableFishIntegration = true;
    };

    yazi = {
      enable = true;
      enableFishIntegration = true;
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
    };

    zellij = {
      enable = true;
      settings.default_shell = "fish";
    };
  };
}
