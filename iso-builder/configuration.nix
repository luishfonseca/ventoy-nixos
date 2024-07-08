{pkgs, ...}: {
  nix.extraOptions = "experimental-features = nix-command flakes";

  isoImage.contents = [
    {
      source = ./ts.key;
      target = "/ts.key";
    }
    {
      source = ./ssh_host_ed25519_key;
      target = "/ssh_host_ed25519_key";
    }
    {
      source = ./authorized_keys;
      target = "/authorized_keys";
    }
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

  services.openssh.authorizedKeysFiles = ["/iso/authorized_keys"];

  services.getty.autologinUser = pkgs.lib.mkForce "root";
}