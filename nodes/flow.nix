/*
  Use
  cp nodes/flow.nix  /etc/nixos/configuration.nix
  nixos-rebuild switch

  --------
  force download of tarball , for dotfiles,

    nixos-rebuild  --option tarball-ttl 60  switch

  keep the git commit for local repo nixpks, consistent with the channel, so that libraries/dependencies are all identical .
    can then do rebuild switch for most stuff without needing the -I argument
    but means can use shell -p -I against local repo, for exceptional packages (kicad), that have local modifications.

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

  pipewire volume. mar. 2025.
  wpctl set-volume @DEFAULT_AUDIO_SINK@   80%

  # old. alsa
  alsactl init        (must be root?)
  pulseaudio --kill   (as user)
  pulseaudio --start
  alsamixer           (verify working)


  # old
  nixos-rebuild build -I nixpkgs=/home/me/devel/nixpkgs/ switch

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




  boot.kernel = {
    sysctl = {
      "net.ipv4.conf.all.forwarding" = true;
      "net.ipv6.conf.all.forwarding" = false;
    };
  };



  # https://discourse.nixos.org/t/lockups-with-kernel-6-14-7-and-amd-gpus/64585/9
  # dmesg [Thu Jul  3 09:18:27 2025] Command line: ...  mem_sleep_default=s2idle amdgpu.noretry=0 amdgpu.vm_update_mode=3 amdgpu.sg_display=0 amdgpu.preempt_mm=0 loglevel=4
  # net.ifnames=0 lsm=landlock,yama,bpf nvidia-drm.modeset=1 nvidia-drm.fbdev=1
  boot.kernelParams = [
    # example settings
    #"quiet"
    #"splash"
    #"usbcore.blinkenlights=1"

    "mem_sleep_default=s2idle"
    "amdgpu.noretry=0"
    "amdgpu.vm_update_mode=3"
    "amdgpu.sg_display=0"
    "amdgpu.preempt_mm=0"
  ];



  boot.extraModulePackages = with config.boot.kernelPackages; [
    # linux-gpib  - fails to compile 25.05.

  ];

  # boot.extraModulePackages = [ ];


  # nvidia drm fails to build against 5.13 kernel, ie. nixos master branch jul 17 2021
  # so use 5.12 instead.
  # https://github.com/NixOS/nixpkgs/issues/130130

  # nvidia drm compiles fine for 5.18 latest. jun 8. 2022.
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages_5_12;


  # april 2025. try older kernel.  6.1 was default for nixos 23.11. Tapir.

  # june 2025. use normal kernel with upgrade.
  # boot.kernelPackages = pkgs.linuxPackages_6_1;



  # Use the systemd-boot EFI boot loader.

  # removed, to avoid error warning. jun 8. 2022.

  # dec 2023. systemd-boot instead of grub
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # mar 2024
  # boot.loader.grub.memtest86.enable = true;
  # https://search.nixos.org/options?channel=23.11&show=boot.loader.systemd-boot.extraEntries&from=0&size=50&sort=relevance&type=packages&query=systemd-boot
  boot.loader.systemd-boot.memtest86.enable = true;

/*
  # dec 2023. leave default in hardware-configuration.nix
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


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  #system.stateVersion = "20.09"; # Did you read the comment?

  # dec 2023.
  # system.stateVersion = "23.11";
  # mar 2025.
  system.stateVersion = "24.11";



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

    # also see.
    # boot.kernelParams = [ "net.ifnames=0" ];
    # june 2024. worked to give wlan0. on boot.
    # looks like turns on ifnames=0
    # cat /proc/cmdline  shows  net.ifnames=0 present
    usePredictableInterfaceNames = false;

    # " The firewall is enabled when not set. " eg. now default, dec 2023.
    # need to reboot?
    firewall.enable = false;



    hostName = "flow"; # Define your hostname.
    # JA
    # wpa_passphrase essid pass > /etc/wpa_supplicant.conf
    wireless.enable = true;  # Enables wireless support via wpa_supplicant.
                             # doesn't affect usb-c phone connection. dec 2023.

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
    # JA apr 2024
    wireless.interfaces = [ "wlan0" ] ;


    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    #interfaces.enp3s0.useDHCP = true;
    # JA apr 2024
    interfaces.wlan0.useDHCP = true;

    # usb/mobile connection sharing. dhcp brings up everything by defaultwhen cable plugged. nice.
    # use 'route' to check interface used.
    # note. disconnect takes about 30s to revert.

    # OTG usb to ethernet. warning. slows boot, as waits for a minute.
    # interfaces.enp6s0f4u1.useDHCP = true;


    # dec 2023 - disable by default. but these do work.
    # feb 23 2022.
    # dmesg. rndis_host 1-1:1.0 enp6s0f3u1: renamed from usb0
    #interfaces.enp6s0f3u1.useDHCP = true;     # usb-A to c cable
    #interfaces.enp6s0f4u1.useDHCP = true;     # white usb-c cable.  aug 1. 2022
    #interfaces.enp6s0f4u2.useDHCP = true;     # white usb-c cable.  aug 1. 2022

    # disable. to avoid stall at boot time. mar 2024
    #interfaces.enp6s0f4u1.useDHCP = true;     # white usb-c cable.  dec 2023.
    #interfaces.enp6s0f3u1.useDHCP = true;     # usb-A to c cable.  dec 2023.


    # worked. white usb cable. april 2025.  kernel 6.1.131
    interfaces.eth0.useDHCP = true;


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
      '';

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # or disable the firewall altogether.
    # networking.firewall.enable = false;


    /* Jun 2024. Not sure any of this is relevant */
#
#    # static assignment worked. but took a little while to come up,
#    # it also added a route
#    # https://search.nixos.org/options?channel=23.11&show=networking.interfaces.%3Cname%3E.ipv4.addresses&from=0&size=50&sort=relevance&type=packages&query=networking.interfaces
#    interfaces.usb0 = {
#
#      # use dhcp = true for usb phone tethering. can change dhcp = false for  static ip assign. for ethernet devel.
#      useDHCP = true;
#    };
#
#
#    /* static ip assigment. local net. using usb-to wired ethernet
#        works- just need rebuild switch, and can change ip.
#    */
#    interfaces.eth0 = {
#      ipv4.addresses = [
#          {
#        address = "10.0.0.1";
#        prefixLength = 24;
#        }
#      ] ;
#    };

  };




  # remember we need the masquerade, iptables rule, if want external connection from client.

  # refs,
  # https://l33tsource.com/blog/2022/11/06/Build-a-dns-server-on-NixOS/
  # https://search.nixos.org/options?channel=23.11&show=services.dnsmasq.settings&from=0&size=50&sort=alpha_asc&type=packages&query=services.dnsmasq
  # https://nixos.wiki/wiki/Internet_Connection_Sharing

  # systemctl status dnsmasq
  # journalctl --unit dnsmasq

  # Jun 20. 2024.  dhcp worked with mongoose application.
  # but needed manual ifconfig eth0 up
#
#  services.dnsmasq = {
#
#    enable = true;
#    resolveLocalQueries = false;
#
#    settings = {
#      interface = "eth0";     /* not usb0 !!!*/
#
#      /* listen-address="10.0.0.1"; not needed, if ip on is already statically assigned with 'interfaces.eth0.ipv4.addresses'.
#          not needed for layer2 dhcpd anyway.
#      */
#      /* make sure no default server, which kills */
#      servers = [ ];
#
#      dhcp-range = [ "10.0.0.10,10.0.0.20" ];
#    };
#  };
#

  /* dhcpd4  no longer supported

  */


/*
  systemd.network.networks."10-lan" = {
    matchConfig.Name = "lan";
    networkConfig.DHCP = "ipv4";
  };
*/
/*
  # // useDHCP = false;
  # networking.useNetworkd = true;
  systemd.network.enable = true;

    systemd.network = {

      # usb0

      networks."10-usb0" = {
        # match the interface by name
        matchConfig.Name = "usb0";
        address = [
            # configure addresses including subnet mask
            "192.0.2.100/24"
            "2001:DB8::2/64"
        ];
        routes = [
          # create default routes for both IPv6 and IPv4
          { routeConfig.Gateway = "fe80::1"; }
          { routeConfig.Gateway = "192.0.2.1"; }
          # or when the gateway is not on the same network
          { routeConfig = {
            Gateway = "172.31.1.1";
            GatewayOnLink = true;
          }; }
        ];
        # make the routes on this interface a dependency for network-online.target
        linkConfig.RequiredForOnline = "routable";
      };

/*
    address = [
        # configure addresses including subnet mask
        "192.0.2.100/24"
        "2001:DB8::2/64"
    ];

        netdevs = {
          # Create the bridge interface
          "20-br-lan" = {
            netdevConfig = {
              Kind = "bridge";
              Name = "br-lan";
            };
          };
        };

        networks = {
          # Connect the bridge ports to the bridge
          "30-lan0" = {
            matchConfig.Name = "usb0";
            networkConfig = {
              Bridge = "br-lan";
              ConfigureWithoutCarrier = true;
            };
            linkConfig.RequiredForOnline = "enslaved";
          };
        };

    };
*/

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

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
        haskellPackages.xmonad
      ];


      # dec 2023.
      # https://nixos.wiki/wiki/XMonad
      # config file needs to be defined rather than just picking up ~/.xmonad/xmonad.hs.
      # xmobar is still picked up as ~/.xmobarrc

      # to check status if display manage service fails.
      # systemctl status display-manager.service

      # to restart window system
      # systemctl restart display-manager.service

      config = builtins.readFile "${dotfilesSrc}/xmonad.hs";
    };

  };




  # windowManager.default = "xmonad";
  services.displayManager.defaultSession = "none+xmonad";



  services.xserver.displayManager.sessionCommands =
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
  ''

    ${pkgs.xorg.xrdb}/bin/xrdb --merge ${myXResources};

    # doesn't work need to copy Xresources
    ${pkgs.xorg.xmodmap}/bin/xmodmap ${myCustomLayout};

    # keyboard repeat rate
    ${pkgs.xorg.xset}/bin/xset r rate 200 ;

  '';

#    ${pkgs.xorg.xrdb}/bin/xrdb --merge ${myXResources}



  # for unrar but doesn't seem to work.
  nixpkgs.config.allowUnfree = true;

  # something needs old python

      nixpkgs.config.permittedInsecurePackages = [
	"python-2.7.18.7"
      ];



  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {

    #  see https://nixos.wiki/wiki/Nvidia

    # add these march 2025.
    # Modesetting is required.
    modesetting.enable = true;

    open = false;

    prime = {
      offload.enable = true;

      # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
      #intelBusId = "PCI:0:2:0";

      # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
      #nvidiaBusId = "PCI:1:0:0";

      # JA apr 2024
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:9:0:0";
    };
  };

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
  # services.xserver.videoDrivers = [ "nvidia" ];
  # services.xserver.videoDrivers = [ "modsetting" "nvidia" ];

  # we need this.
  # https://github.com/NixOS/nixpkgs/pull/116816

  # deprecated but might help
  # https://old.reddit.com/r/NixOS/comments/kzrloo/powering_nvidia_card_on_and_off/
  # hardware.bumblebee.enable = true;

#  hardware.nvidia.prime = {
#    sync.enable = true;
#
#    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
#    nvidiaBusId = "PCI:1:0:0";
#   # //  06:00.0
#    amdgpuBusId  = "PCI:6:0:0";
#
#  };



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






  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable sound.

  # disable march 2025. upgrade to 24.11
  # sound.enable = true;
  # disable march 2025.
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # JA

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

    # can remove later
    linuxPackages.cpupower
    lm_sensors
    lshw
    pciutils
    usbutils
    # radeon-profile gui app. works.

    # networking
    whois
    traceroute
    dig
    sshfs

    git-crypt

    evince
    feh
    trezord
    scrot


    ###############

    awscli   # for backup

    imagemagick   # convert

    # public lectures, youtube download
    yt-dlp

    gpu-screen-recorder
    # gpu-screen-recorder-gtk
    #kdenlive      # video edit

    mpv
    oath-toolkit   # 2fa
    netcat-openbsd    # overide default netcat

    (ffmpeg.override { withXcb = true; })  # ffmpeg screen/desk recorder


    # numerical
    octave
    gnuplot
    ghostscript

    # nice. simple photo drawing, editing.
    pinta

    # linux-gpib   # fails to build 25.05
    astrolog

    # anki

    a2ps
    dconf


    # scanimage from hardware.sane
    # tiffcp
    # tiff2pdf
    libtiff
    sane-backends



    ########################

    # large apps, with heavy compile dependencies.

    chromium

    firefox        # 26.05 wants to compile. firefox failed to build, hung when running rustc.
    thunderbird    # 25.05. wants to compile it.

    # freecad  # don't use. instead use 1.0.1 version from master.
    # libreoffice

    # wine   # for ltspice

    # openscad
    # openscad-unstable

    # kicad   # v8.

/*
    darktable
    exiftool

    # mlocate   # says does not appear to be valid db

    # rxvt-unicode . use nix-shell -p.
    # libreoffice - to convert ltspice images to something png.
    libreoffice

    # kicad7.  use local repo for kicad v6
    kicad

    # digilent waveforms, patchelf for patching binaries
    dpkg patchelf nix-index
    qt5.qtmultimedia
    qt5.qtscript
    xdg-utils

*/
  ];



  # in programs, for suid, needed to disable oom.
  # needs reboot
  programs.slock.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = tRUE;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

/*
  # Enable the OpenSSH daemon.
  # JA
  services.openssh.enable = true;

  # services.openssh.permitRootLogin = "prohibit-password";
    services.openssh.settings.PermitRootLogin = "prohibit-password";   # apr 2023.
*/


  ##################
  # scanner
  # https://nixos.wiki/wiki/Scanners
  # LIDE
  # found possible USB scanner (vendor=0x04a9 [Canon], product=0x220d [CanoScan], chip=LM9832/3) at libusb:003:008
  #  https://github.com/NixOS/nixpkgs/issues/273280
  # hardware.sane.enable = true; # enables support for SANE scanners
  # https://issues.guix.gnu.org/73406

  # https://github.com/NixOS/nixpkgs/pull/328459  fix.

  #services.ipp-usb.enable=true;

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



  ############
  # OLD.
  # https://nixos.wiki/wiki/Printing
  # https://blog.dwagenk.com/nix/2020/04/nix-printing/

  # can navigate to http://localhost:631/ now.

  # find /nix/ | grep  yourppd
  # /nix/store/nwb7mhgwsp9qbmq98anvhzcnmzzmisx7-cups-progs/share/cups/model/yourppd.ppd

  # configure after install.
  # lpadmin -p 'Brother' -v 'socket://192.168.0.8:9100' -P '/root/nixos-config/nodes/BRHL16_2_GPL.ppd'  -E
  # lpadmin -p 'Brother' -v 'socket://192.168.0.8:9100' -P '/nix/store/incn73f2iqls7m0v38y2mx3a2lbwv02f-yourppd.ppd.drv' -E
  # /nix/store/nwb7mhgwsp9qbmq98anvhzcnmzzmisx7-cups-progs/share/cups/model/yourppd.ppd

  # configure default
  # lpadmin -d 'Brother'

  ################################
  # jan 2024, this appeared to correctly manually configure the printer.

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


# not needed for devanagari in firefox, libreoffice.
#  fonts.fonts = with pkgs; [
#    lohit-fonts.devanagari
#    annapurna-sil
#   ];


#  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # https://search.nixos.org/options?channel=23.11&show=services.earlyoom.enable&from=0&size=50&sort=relevance&type=packages&query=earlyoom
  services.earlyoom.enable = true;


}


