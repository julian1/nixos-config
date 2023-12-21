/*

  =====================
  EXTR
  don't need to sym-link /etc/nixos/configuration.nix
  just sudo/su and,

  nixos-rebuild build -I nixpkgs=/home/me/devel/nixpkgs/  -I  nixos-config=./nodes/zephyrus.nix     switch


  hardware-configuration.nix stays in /etc/nixos/
  =====================


  must use master branch of pkgs, for latest nvidia driver.
  commit 881ebaacf820f72

  careful. kernel updates, and rebuild of will nvidia driver will kill Xorg and all open applications.
  even if don't reboot.

  boot, brightness
  $ cat /sys/class/backlight/amdgpu_bl1/brightness

  keyboard brightness
  echo 0 >  /sys/class/leds/asus::kbd_backlight/brightness

  xrand brightness
  xrandr --output eDP --brightness .4


  sharing xwindows
  xhost + local:      (for containers/apps run under different users that need to share Xorg)
  alsactl init        (must be root?)
  pulseaudio --kill   (as user)
  pulseaudio --start
  alsamixer           (verify working)



  nixos-rebuild build -I nixpkgs=/home/me/devel/nixpkgs/ switch

*/
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:


{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # /etc/nixos/hardware-configuration.nix

      #/root/nixos-config/common/users.nix
      #c/root/nixos-config/common/dotfiles.nix
      #/root/nixos-config/common/low-battery-monitor.nix

      #/root/nixos-config/waveforms-flake/pkgs/adept2-runtime/default.nix

    ];



  # nvidia drm fails to build against 5.13 kernel, ie. nixos master branch jul 17 2021
  # so use 5.12 instead.
  # https://github.com/NixOS/nixpkgs/issues/130130

  # nvidia drm compiles fine for 5.18 latest. jun 8. 2022.
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages_5_12;

  # Use the systemd-boot EFI boot loader.

  # removed, to avoid error warning. jun 8. 2022.

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


/*

  #####
  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = true;
    enableCryptodisk = true;
    device = "nodev";
  };


  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-uuid/b74944f9-895e-44d0-aaea-006d10f22af7";
      # preLVM = true;
      #preLVM = false;
    };
  };
  #####
*/

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";
  time.timeZone = "Australia/Hobart";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };


  networking = {

    hostName = "zephyrus"; # Define your hostname.
    # JA
    # wpa_passphrase essid pass > /etc/wpa_supplicant.conf
    wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # don't use for public hosted code. rely on /etc/wpa_supplicant.conf instead.
    # wireless.networks = {
    #  #  exampleSSID = {
    #  #    pskRaw = "46c25aa68ccb90945621c1f1adbe93683f884f5f31c6e2d524eb6b446642762d"; };
    #};

    ## apr 2023. OK. wpa_supplicant.conf can have multiple entries. so use that instead of configuring here,
    #  because pskRaw is enough to authenticate.
    # format,
    # network={ ssid="xxx" psk=xxx }   network={ ssid="xxx" psk=xxx }  etc.


    # get warning if not configured,  https://nixos.org/manual/nixos/stable/options.html
    wireless.interfaces = [ "wlp4s0" ] ;


    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp3s0.useDHCP = true;
    interfaces.wlp4s0.useDHCP = true;

    # usb/mobile connection sharing. dhcp brings up everything by defaultwhen cable plugged. nice.
    # use 'route' to check interface used.
    # note. disconnect takes about 30s to revert.

    # OTG usb to ethernet. warning. slows boot, as waits for a minute.
    # interfaces.enp6s0f4u1.useDHCP = true;

    # feb 23 2022.
    # dmesg. rndis_host 1-1:1.0 enp6s0f3u1: renamed from usb0
    #interfaces.enp6s0f3u1.useDHCP = true;     # usb-A to c cable
    #interfaces.enp6s0f4u1.useDHCP = true;     # white usb-c cable.  aug 1. 2022
    #interfaces.enp6s0f4u2.useDHCP = true;     # white usb-c cable.  aug 1. 2022




    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    extraHosts =
      ''
        127.0.0.2 other-localhost
        192.168.0.4   dell
        3.25.161.11   aws3
      '';

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # or disable the firewall altogether.
    # networking.firewall.enable = false;

  };

}


