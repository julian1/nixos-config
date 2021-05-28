# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

   # JA
  let
    myCustomLayout = pkgs.writeText "xkb-layout" ''
      ! Map umlauts to RIGHT ALT + <key>

      keycode 96 = Insert Insert

      !keysym e = e E EuroSign
      !keysym c = c C cent
      !keysym a = a A adiaeresis Adiaeresis
      !keysym o = o O odiaeresis Odiaeresis
      !keysym u = u U udiaeresis Udiaeresis
      !keysym s = s S ssharp

      ! disable capslock
      ! remove Lock = Caps_Lock
    '';


  # this doesn't work. need to copy Xresources to $HOME
  in
    let myXResources = pkgs.writeText "xresources" ''
      XTerm*selectToClipboard: true
    '';
in


{
  imports =
    [ # Include the results of the hardware scan.
      #./hardware-configuration.nix
      /etc/nixos/hardware-configuration.nix

      /root/nixos-config/common/users.nix
      /root/nixos-config/common/dotfiles.nix
    ];

  #OK. nvidia does compile against non latest. but xorg won't start.
  # against non latest kernel.

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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



  networking.hostName = "zephyrus"; # Define your hostname.
  # JA
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  #networking.wireless.networks = {
#
#  }

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";
  time.timeZone = "Australia/Hobart";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  # JA
  services.xserver.enable = true;



  services.xserver = {

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
        haskellPackages.xmonad
      ];
    };

    # windowManager.default = "xmonad";
    displayManager.defaultSession = "none+xmonad";
  };

  services.xserver.displayManager.sessionCommands = ''

    ${pkgs.xorg.xrdb}/bin/xrdb --merge ${myXResources};

    # doesn't work need to copy Xresources
    ${pkgs.xorg.xmodmap}/bin/xmodmap ${myCustomLayout};

    # keyboard repeat rate
    ${pkgs.xorg.xset}/bin/xset r rate 200 ;

  '';

#    ${pkgs.xorg.xrdb}/bin/xrdb --merge ${myXResources}




  nixpkgs.config.allowUnfree = true;

  ############################################
  # JA
  # fails to build. may 28, 2021 
  # https://discourse.nixos.org/t/nixos-config-build-failes-with-latest-kernel/12273
  # services.xserver.videoDrivers = [ "nvidia" ];


  # Example for NixOS 20.09/unstable
  # build fails against recent 5.11.21 kernel. missing asm/kmap_types.h:
  # report.  https://www.linuxtoday.com/developer/nvidia-460.67-graphics-driver-released-with-better-support-for-linux-5.11-bug-fixes-210318111002.html
  # we need,  NVIDIA 460.67 

  #   version = "460.73.01"; 
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable_390;
  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable_460;


  # This builds on master branch of nixpkgs, eg. pulls in nvidea 460
  # nixos-rebuild build -I nixpkgs=/home/me/devel/nixpkgs/  switch
  # <S-F12> 
  # eg. incorporates,  nixos-rebuild build -I nixpkgs=/home/me/devel/nixpkgs/
  services.xserver.videoDrivers = [ "nvidia" ];
  #services.xserver.videoDrivers = [ "modsetting" "nvidia" ];

  # we need this.
  # https://github.com/NixOS/nixpkgs/pull/116816

  # deprecated but might help
  # https://old.reddit.com/r/NixOS/comments/kzrloo/powering_nvidia_card_on_and_off/
  # hardware.bumblebee.enable = true;

  hardware.nvidia.prime = {
    sync.enable = true;
#
#    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";
###
###    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
###    intelBusId = "PCI:0:2:0";
##
##    # //  06:00.0
    amdgpuBusId  = "PCI:6:0:0";
##
#    #amdgpuBusId = "PCI:6:0:0";
##    package = config.boot.kernelPackages.nvidiaPackages.stable_460;
#
  };



  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # JA
  environment.systemPackages = with pkgs; [
     wpa_supplicant
     screen
     vim
     git
     file tree

      #####
     xorg.xev      # for keycodes
     xorg.xmodmap  # to experiment with remapping
     xorg.xhost   # change persmissions, to permit other sessions
     # xrdb is installed by default
     # xclip   for copying into a shell
     glxinfo


    ###############################
    dmenu                    # A menu for use with xmonad
    haskellPackages.xmobar   # A Minimalistic Text Based Status Bar
    #haskellPackages.libmpd   # Shows MPD status in xmobar
    ###############################

    firefox
    evince
    thunderbird
    feh
    openssl     # backup/restore
    zip  unzip
    # scrot
    # wget use curl instead
    #

    # can remove later
    linuxPackages.cpupower 
    lm_sensors
    lshw
    pciutils
    # radeon-profile gui app. works.

  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # JA
  services.openssh.enable = true;

  services.openssh.permitRootLogin = "prohibit-password";

  networking.extraHosts =
    ''
      127.0.0.2 other-localhost
      192.168.0.4   dell
      3.25.161.11   aws3
    '';

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}


