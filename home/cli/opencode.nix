{
  flake.homeModules.opencode = {
    pkgs,
    inputs,
    ...
  }: let
    agents =
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};

    oriFishCompletion = pkgs.runCommand "ori-fish-completion" {} ''
      ${agents.ori}/bin/ori --completions fish > $out
    '';
  in {
    home.packages = [
      agents.ori
      agents.opencode
    ];

    xdg.configFile."fish/completions/ori.fish".source =
      oriFishCompletion;
  };
}
