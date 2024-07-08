# Ventoy + NixOS

This repository contains the necessary files to create a bootable USB drive with Ventoy and NixOS.

It extends the minimal NixOS installer to auto connect to a Tailnet and allow SSH access with a public key.

Perfect for installing NixOS on a headless machine.

## Requirements

- A USB drive with Ventoy freshly installed

## Usage

1. Mount the Ventoy USB drive first partition on `/tmp/ventoy`.
2. `git clone git@github.com:luishfonseca/ventoy-nixos.git /tmp/ventoy`
3. Populate the `/tmp/ventoy/iso-builder/content` folder with:
   1. `authorized_keys` - Add your public key here.
   2. `ssh_host_ed25519_key` - Generate a new host key just for this.
   3. `ts.key` - A Tailscale auth key, should be ephemeral.
4. `cd /tmp/ventoy/iso-builder`
5. `./build_iso.sh`
6. Add any other ISOs you want to boot from Ventoy to the `ISO` folder.

Now just boot from the USB drive and NixOS should be selected by default.
After a couple minutes, you should be able to see it on your tailnet.

## Warning

`iso-builder/content` files end up in the host system's nix store, keep that in mind.
