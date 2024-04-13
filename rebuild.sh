#!/usr/bin/env bash

set -e

cd $HOME/nix 

alejandra . &>/dev/null || ( alejandra . ; echo "formatting failed!" && exit 1)

git add . 
git diff -U0 --staged

sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --flake .#$HOST --impure

cd -

rm -f ~/.zshenv

# Notify all OK!
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
exec zsh -l