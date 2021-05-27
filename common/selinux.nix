
/*
  from, https://nixos.wiki/wiki/Workgroup:SELinux

  https://github.com/NixOS/nix/pull/2670/files
  https://lore.kernel.org/selinux/7853167.K65cXu0y11@neuromancer/T/#u
  https://old.reddit.com/r/NixOS/comments/m5gcyd/can_you_help_me_setup_selinux_on_nixos/
*/

{ lib,  pkgs, ... }:

with lib;
{
  # tell kernel to use SE Linux
   boot.kernelParams = [ "security=selinux" ];
  # compile kernel with SE Linux support - but also support for other LSM modules
   boot.kernelPatches = [ {
         name = "selinux-config";
         patch = null;
         extraConfig =  ''
                 SECURITY_SELINUX y
                 SECURITY_SELINUX_BOOTPARAM n
                 SECURITY_SELINUX_DISABLE n
                 SECURITY_SELINUX_DEVELOP y
                 SECURITY_SELINUX_AVC_STATS y
                 SECURITY_SELINUX_CHECKREQPROT_VALUE 0
                 DEFAULT_SECURITY_SELINUX n
      ''
               ;
         } ];

  # for some reason the below doesn't work. 
  # the kernel recom

  # policycoreutils is for load_policy, fixfiles, setfiles, setsebool, semodile, and sestatus.
  #environment.systemPackages = with pkgs; [ policycoreutils ];
  # build systemd with SE Linux support so it loads policy at boot and supports file labelling
  #systemd.package = pkgs.systemd.override { withSelinux = true; };
}

