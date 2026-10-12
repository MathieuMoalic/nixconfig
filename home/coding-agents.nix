{
  flake.homeModules.coding-agents = {pkgs, ...}: {
    home.packages = with pkgs.llm-agents; [
      opencode
      kilocode-cli
      ori
      copilot-cli
    ];
  };
}
