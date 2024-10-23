{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    just # makefile in rust
    alejandra # format nix
    nixd # nix LSP
    taplo # toml LSP
    dockerfile-language-server-nodejs # dockerfile lsp
    delta # diff
    ffmpeg
  ];
  # Needed by nixd
  nix.nixPath = [
    "nixpkgs=${inputs.nixpkgs}"
  ];
}
