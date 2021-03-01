{ config, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/virtualisation/lxc-container.nix> ] ++
  [
    # /home/me/nixos-config/common/multi-glibc-locale-paths.nix
    /home/me/nixos-config/common/locale19.nix   # note. v19
    /home/me/nixos-config/common/users.nix

    # to force dotfiles upgrade,  
    # nixos-rebuild  switch --upgrade  --option tarball-ttl 0
    /home/me/nixos-config/common/dotfiles.nix
  ];

	
  # config.allowUnfree = true;

  config.networking.hostName = "nspawn-nixos-03";

  config.networking.firewall.enable = false;

  # static ip address
  config.networking = {
    interfaces.host0.ipv4.addresses = [{
      address = "10.3.0.31";
      prefixLength = 24;
    }];
    defaultGateway = "10.3.0.1";
    nameservers = [ "8.8.8.8" ];
  };

  # show ip address,
  config.services.mingetty.greetingLine = pkgs.lib.mkForce ''<<< \4, Welcome to NixOS, (\m) - \l >>>'';


  ########################
  # Enable the OpenSSH daemon.
  config.services.openssh.enable = true;

  # Nov 2020. AWS conflict.
  config.services.openssh.permitRootLogin = "prohibit-password";

  # No X11 forwarding /ssh -Y. use /tmp/.X11-unix/  instead.
  # xhost + local:   and restart term.
  # ssh nixos03
  # export DISPLAY=:0
  # xeyes 

}


# usePredictableInterfaceNames = false;
# usePredictableInterfaceNames = true;
#  interfaces.eth0.ip4 
# interfaces.host0.ip4.addresses = [{

# interfaces.host0.ip4 = [{

