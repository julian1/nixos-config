/*
  note. not for nano isntance.
  tested on 4GB to build stuff, and 20GN storage.
  else oom.

*/
{ modulesPath, lib, pkgs, ... }: {
  imports = [ "${modulesPath}/virtualisation/amazon-image.nix" 

	/root/nixos-config/common/users.nix
	/root/nixos-config/common/dotfiles.nix

	/root/nixos-config/common/selinux.nix
];
  ec2.hvm = true;


  networking.hostName = "aws3"; # Define your hostname.

  time.timeZone = "Australia/Hobart";

   
  environment.systemPackages = with pkgs; [ policycoreutils ];

  systemd.package = pkgs.systemd.override { withSelinux = true; };

  ####
  ## ok. got it enabled (with sestatus), with the following,
  # cat /etc/selinux/config

#  # This file controls the state of SELinux on the system.
#  # SELINUX= can take one of these three values:
#  #       enforcing - SELinux security policy is enforced.
#  #       permissive - SELinux prints warnings instead of enforcing.
#  #       disabled - No SELinux policy is loaded.
#  SELINUX=permissive
#  # SELINUXTYPE= can take one of these two values:
#  #       targeted - Targeted processes are protected,
#  #       mls - Multi Level Security protection.
#  SELINUXTYPE=targeted

}
