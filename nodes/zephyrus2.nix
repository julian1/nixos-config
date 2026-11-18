/*
  zephyrus2.


*/

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

    let
      # see, https://nixos.wiki/wiki/How_to_fetch_Nixpkgs_with_an_empty_NIX_PATH
      dotfilesSrc = builtins.fetchTarball {
        url = "https://github.com/julian1/dotfiles/archive/master.tar.gz";
        #inherit sha256;

      };
    in


{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # /etc/nixos/hardware-configuration.nix

      /root/nixos-config/common/users.nix
      /root/nixos-config/common/dotfiles.nix
      /root/nixos-config/common/low-battery-monitor.nix
      /root/nixos-config/common/gitconfig-change.nix

      #/ROOt/nixos-config/waveforms-flake/pkgs/adept2-runtime/default.nix

    ];



  #########################

  # from default configuration
  # nixos-generate-config --root /mnt

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # do not touch. even if upgrade
  system.stateVersion = "26.05";

  #########################


  boot.loader.systemd-boot.memtest86.enable = true;



  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";
  time.timeZone = "Australia/Hobart";
  # time.timeZone = "Asia/Hong_Kong";




  networking = {

    # also see.
    # boot.kernelParams = [ "net.ifnames=0" ];
    # june 2024. worked to give wlan0. on boot.
    # looks like turns on ifnames=0
    # cat /proc/cmdline  shows  net.ifnames=0 present
    usePredictableInterfaceNames = false;

    # " The firewall is enabled when not set. " eg. now default, dec 2023.
    # need to reboot?
    firewall.enable = false;



    hostName = "zephyrus2"; # Define your hostname.
    # JA
    # wpa_passphrase essid pass > /etc/wpa_supplicant.conf
    wireless.enable = true;  # Enables wireless support via wpa_supplicant.
                             # doesn't affect usb-c phone connection. dec 2023.


    # get warning if not configured,  https://nixos.org/manual/nixos/stable/options.html
    # JA apr 2024
    wireless.interfaces = [ "wlan0" ] ;



    # nameservers = [ "1.1.1.1" "9.9.9.9" ];    # cloudfare
    nameservers = [ "8.8.8.8"  ];             # google


    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    extraHosts =
      ''
        127.0.0.2 other-localhost
        192.168.0.4   dell
        192.168.0.2   zephyrus
        192.168.0.8   brother
        3.25.161.11   aws3

        127.0.0.1     va.v.liveperson.net
        127.0.0.1     v.liveperson.net
        127.0.0.1     liveperson.net


        # nitter.cf
        # 104.21.62.204 xcancel.com

      '';

  };




  services.udev = {
      extraRules = ''
        # SUBSYSTEM=="usb", ACTION=="add|remove", ENV{ID_VENDOR}=="Lenovo", ENV{ID_MODEL}=="Lenovo_ThinkPad_Dock", RUN+="${pkgs.bash}/bin/bash /home/hoodoo/.local/bin/dock_handler.sh"

        # JA old. from ansible.
        # thumb drive?
        # SUBSYSTEM=="block", ATTRS{idVendor}=="058f", ATTRS{idProduct}=="6387", MODE="0666", OWNER="me"


        # for /dev/ttyUSB0 eg. usb to uart, use group 'dialout'. changing device ownwer doesn't appear to work.

        # ice40 / fpga works!
        # https://stackoverflow.com/questions/36633819/iceprog-cant-find-ice-ftdi-usb-device-linux-permission-issue
        # Bus 001 Device 040: ID 0403:6014 Future Technology Devices International, Ltd FT232H Single HS USB-UART/FIFO IC
        ACTION=="add", ATTR{idVendor}=="0403", ATTR{idProduct}=="6014", MODE:="666", OWNER="me"


        # stlink v2 works!
        ACTION=="add", ATTR{idVendor}=="0483", ATTR{idProduct}=="3748", MODE:="666", OWNER="me"

        # tzrd
        # ACTION=="add", ATTR{idVendor}=="534c", ATTR{idProduct}=="0001", MODE:="666", OWNER="trusted"



        # Trezor
        SUBSYSTEM=="usb", ATTR{idVendor}=="534c", ATTR{idProduct}=="0001", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="trezor%n"
        KERNEL=="hidraw*", ATTRS{idVendor}=="534c", ATTRS{idProduct}=="0001", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl"

        # Trezor v2
        SUBSYSTEM=="usb", ATTR{idVendor}=="1209", ATTR{idProduct}=="53c0", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="trezor%n"
        SUBSYSTEM=="usb", ATTR{idVendor}=="1209", ATTR{idProduct}=="53c1", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="trezor%n"
        KERNEL=="hidraw*", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="53c1", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl"


        # stlink v3, may 2025.
        ACTION=="add", ATTR{idVendor}=="0483", ATTR{idProduct}=="3754", MODE:="666", OWNER="me"


      '';
  };



  ###############################################
  # Enable the X11 windowing system.
  # JA



  services.xserver = {

    enable = true;


    # Inject custom xorg.conf.d snippets

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
        haskellPackages.xmonad
      ];


      config = builtins.readFile "${dotfilesSrc}/xmonad.hs";
    };

  };

  # windowManager.default = "xmonad";
  services.displayManager.defaultSession = "none+xmonad";




  # for unrar but doesn't seem to work.
  nixpkgs.config.allowUnfree = true;



  # something needs old python

      nixpkgs.config.permittedInsecurePackages = [
	"python-2.7.18.7"
      ];


  # dec . 2025.
  # https://nixos.wiki/wiki/AMD_GPU
  boot.initrd.kernelModules = [ "amdgpu" ];
  # services.xserver.enable = true;  defined earlier
  services.xserver.videoDrivers = [ "amdgpu" ];





  # https://discourse.nixos.org/t/alert-sound-randomly-played-after-24-05-upgrade/46367
  # cat /etc/pipewire/pipewire.conf.d/99-silent-bell.conf.conf
  services.pipewire = {
      # ... not relevant part snipped
      extraConfig = {
        pipewire."99-silent-bell.conf" = {
          "context.properties" = {
            "module.x11.bell" = false;
          }; # context.properties
        }; # extraConfig.pipewire
      }; # extraConfig
    }; # pipewire





  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;


  # neat
  # environment.shellAliases = { xtrlock = "xtrlock-pam"; };

  environment.systemPackages = with pkgs;
    let
      nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        exec -a "$0" "$@"
      '';

      # can store.../ xtrlock-pam be referenced before use?
      #xtrlock = pkgs.writeShellScriptBin "xtrlock" "exec -a $0 ${xtrlock-pam}/bin/xtrlock-pam $@";
    in
  [
     wpa_supplicant
     # dhclient
     dhcpcd   # dhcpclient. should be installed by default.
     screen
     vim
     git
     file
     tree

      #####
     xorg.xev      # for keyboard keycodes
     xorg.xmodmap  # to experiment with remapping
     xorg.xhost    # change persmissions, to permit other sessions
     # xrdb is installed by default

     # xclip for clipboard image, copying into a shell - seems to be default included in 2024.
     xclip
     glxinfo
     nvidia-offload


    ###############################
    dmenu                    # A menu for use with xmonad
    haskellPackages.xmobar   # A Minimalistic Text Based Status Bar
    #haskellPackages.libmpd   # Shows MPD status in xmobar


    # xtrlock-pam         # removed in nixos 25.05
    # xtrlock
    ###############################

    openssl     # backup/restore
    zip  unzip
    # wget use curl instead
    #

  ];



  # in programs, for suid, needed to disable oom.
  # needs reboot
  programs.slock.enable = true;


  hardware.sane.enable = true; # enables support for SANE scanners


  nixpkgs.overlays = [
    (final: prev: {
      # Fixes a problem that attempt to access /nix/store/.../var/lock .
      # Without this, the scanner is not detected.
      sane-backends = prev.sane-backends.overrideAttrs
        ({ configureFlags ? [ ], ... }: {
          configureFlags = configureFlags ++ [ "--disable-locking" ];
        });
    })
  ];




  # Enable CUPS to print documents.
  services.printing.enable = true;

  # driver
  services.printing.drivers = [
      (pkgs.writeTextDir "share/cups/model/BRHL16_2_GPL.ppd" (builtins.readFile "/root/nixos-config/nodes/BRHL16_2_GPL.ppd" ))

  ];

  # definition
  hardware.printers = {

    ensurePrinters = [
      {
        name      = "Brother";
        location  = "Home";
        deviceUri = "socket://192.168.0.8:9100";
        model     = "BRHL16_2_GPL.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
    ];
  ensureDefaultPrinter = "Brother";
};

  # show outstanding print jobs.
  # lpstat -p Brother -t
  # lpq
  # lpstat -p
  # http://localhost:631/printers/Brother


  ###################

  # Feb 2. 2026.  worked for firefox, chromium, and gedit.
  #  also manually set devanagari font in firefox. in fonts -> advanced.
  # likely this was not be necessary.
  # rebooted. after change. not just restart desktop.

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif

      # Specific Devanagari fonts
      # Note: These are usually included in the main 'noto-fonts'
      # package, but can be explicitly included if needed.
      # noto-fonts-devanagari (usually redundant if using noto-fonts)

      # oct. 2026
      # corrupted khmer anki text, and made everything italic, after anki restart.
      # khmeros
    ];
  };

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" "Noto Serif Devanagari" ];
        sansSerif = [ "Noto Sans" "Noto Sans Devanagari" ];
        monospace = [ "Noto Sans Mono" ];
      };
    };
  };


  # Ensure your system supports UTF-8, which is required for Devanagari characters:
  i18n.defaultLocale = "en_US.UTF-8";
  # Or explicitly add Hindi
  # i18n.supportedLocales = [ "hi_IN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];

  ###################


  # https://search.nixos.org/options?channel=23.11&show=services.earlyoom.enable&from=0&size=50&sort=relevance&type=packages&query=earlyoom
  services.earlyoom.enable = true;


}


