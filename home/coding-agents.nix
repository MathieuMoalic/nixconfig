{
  flake.homeModules.coding-agents = {pkgs, ...}: {
    home.packages = with pkgs.llm-agents; [
      codex
      opencode
      kilocode-cli
      ori
      copilot-cli
    ];
  };
}
