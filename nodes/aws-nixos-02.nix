# ln -s $(pwd)/aws-nixos-01.nix  /etc/nixos/configuration.nix

{ config, pkgs, ... }:

{

  # AWS
  imports = [ <nixpkgs/nixos/modules/virtualisation/amazon-image.nix> ] ++
  [
    /root/nixos-config/common/multi-glibc-locale-paths.nix
    /root/nixos-config/common/locale19.nix   # note. v19
    /root/nixos-config/common/users.nix
    # to force dotfiles upgrade,  
    # nixos-rebuild  switch --upgrade  --option tarball-ttl 0

    /root/nixos-config/common/dotfiles.nix
  ];

  # AWS
  config.ec2.hvm = true;


	
  # config.allowUnfree = true;

  config.networking.hostName = "aws-nixos-02";

  config.networking.firewall.enable = false;


  # show ip address,
  config.services.mingetty.greetingLine = pkgs.lib.mkForce ''<<< \4, Welcome to NixOS, (\m) - \l >>>'';


  ########################
  # copied out of users

  # Enable the OpenSSH daemon.
  config.services.openssh.enable = true;
  # config.services.openssh.permitRootLogin = "without-password";

  # Nov 2020. AWS conflict.
  config.services.openssh.permitRootLogin = "prohibit-password";

  # NEED TO DISABLE IN ORDER TO UPGRADE
  # Nov 2020 for AWS
  config.services.openssh.forwardX11 = true;

  # ssh will set the display var. etc.
  # xhost + local:   and restart term.
  # ssh -Y aws-nixos-02
  # $ echo $DISPLAY
  # localhost:10.0


}


# usePredictableInterfaceNames = false;
# usePredictableInterfaceNames = true;
#  interfaces.eth0.ip4 
# interfaces.host0.ip4.addresses = [{

# interfaces.host0.ip4 = [{


