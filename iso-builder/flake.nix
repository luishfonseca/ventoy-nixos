{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    pkgs = import nixpkgs {system = "x86_64-linux";};
  in {
    nixosConfigurations."isoimage" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        {
          nix.extraOptions = "experimental-features = nix-command flakes";

          isoImage.contents = [
            { source = ./ts.key; target = "/ts.key"; }
            { source = ./ssh_host_ed25519_key; target = "/ssh_host_ed25519_key"; }
          ];

          services.tailscale = {
            enable = true;
            openFirewall = true;
            authKeyFile = "/iso/ts.key";
          };

          services.openssh.hostKeys = [];
          boot.postBootCommands = ''
            cp /iso/ssh_host_ed25519_key /etc/ssh/
            chmod 400 /etc/ssh/ssh_host_ed25519_key
          '';

          services.getty.autologinUser = pkgs.lib.mkForce "root";

          users.users.root.openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE98aQ0VshDOnylLmZcfEdbuxZllCDtfBYH2786f4nph luis@altair"
          ];
        }
      ];
    };

    packages.x86_64-linux.default = self.nixosConfigurations.isoimage.config.system.build.isoImage;
  };
}
