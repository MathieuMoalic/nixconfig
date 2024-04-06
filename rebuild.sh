#!/usr/bin/env bash

set -e

cd $HOME/nix 

alejandra . &>/dev/null || ( alejandra . ; echo "formatting failed!" && exit 1)

git add . 
git diff -U0

echo "NixOS Rebuilding..."

sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --flake .#$HOST --impure

# Get current generation metadata
current=$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | grep current | grep -oE '[0-9]+' | head -n 1)

# Commit all changes with the generation metadata
git commit -am "$current"

# Back to where you were
cd -

rm -f ~/.zshenv

# Notify all OK!
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
exec zsh -l