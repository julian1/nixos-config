{ modulesPath, lib, ... }:
{
  imports = [ <nixpkgs/nixos/modules/virtualisation/amazon-image.nix> ] ++ [
    /root/nixos-config/common/locale19.nix   # note v19 even though v20pre.
    /root/nixos-config/common/users.nix
    /root/nixos-config/common/keys-extra.nix
    /root/nixos-config/common/dotfiles.nix
    /root/nixos-config/examples2/myparity/service.nix
  ];

  # ok. very important. we should mount the partition on /var/lib rather than /home
  # make easier to link /etc/nixos/configuration to /home/me/nixos-config 
  # without mounting the partition and fstab configuration.
  # actually will need to be /var/lib/parity direct mount. so as not to 
  # incterfere with other os stuff in /var/lib including nixos...

  #ec2.hvm = true;
  config.ec2.hvm = true;

 #  mkfs.ext4   /dev/nvme1n1 
  config.fileSystems."/home" = {
    fsType = "ext4";
    device = "/dev/nvme1n1"; 
    # options = [ "rw" "nofail" ];
    options = [  "errors=remount-ro"  ];
  };

  config.networking.hostName = "dexter02";

  config.networking.firewall.enable = false;


  # this is the aws NAT address, indirect public ip
  config.services.parity.listenAddress = "172.31.54.206";

}

