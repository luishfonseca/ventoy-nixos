#!/usr/bin/env -S nix shell nixpkgs#bash nixpkgs#rsync --command bash

rsync --progress $(nix build --no-link --print-out-paths)/iso/nixos*.iso ../ISO/nixos.iso