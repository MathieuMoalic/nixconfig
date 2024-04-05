#!/usr/bin/env bash

set -e

cd $HOME/nix 

alejandra . &>/dev/null || ( alejandra . ; echo "formatting failed!" && exit 1)

git add . 
git diff -U0 '*.nix'

echo "NixOS Rebuilding..."

# Rebuild, output simplified errors, log trackebacks
sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --flake .#$HOST --impure  #&>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current)

# Commit all changes with the generation metadata
git commit -am "$current"

# Back to where you were
cd -

rm -f ~/.zshenv

# Notify all OK!
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
exec zsh -l