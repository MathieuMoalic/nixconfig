{inputs, ...}: {
  imports = [
    inputs.nix-index-database.hmModules.nix-index # weekly nix-index refresh
  ];
  programs.nushell = {
    enable = true;
    extraConfig = ''
      $env.config = {
        show_banner: false,
        completions: {
          algorithm: "fuzzy",
          },
        }
      $env.DIRENV_LOG_FORMAT = ""
    '';
  };
  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };
  programs.direnv.enableNushellIntegration = true;
  programs.atuin.enableNushellIntegration = true;
  programs.yazi.enableNushellIntegration = true;
  programs.starship.enableNushellIntegration = true;
  programs.zellij.settings.default_shell = "nu";
  # programs.nix-index.enableNushellIntegration = true; # doesn't exist
}
