{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    just # makefile in rust
    alejandra # format nix
    nil # nix LSP
    taplo # toml LSP
    dockerfile-language-server-nodejs # dockerfile lsp
    delta # diff
    go
    gopls
  ];
}
