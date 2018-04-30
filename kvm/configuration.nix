# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./hello-service.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.kernelParams = [ "vga=normal" "fb=false" "console=ttyS0,115200n8" "net.ifnames=0"  "biosdevname=0" ];
  boot.loader.timeout = 0;
  boot.loader.grub.splashImage = null;

#  

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    # defaultLocale = "en_US.UTF-8";
    defaultLocale = "en_AU.UTF-8";

  };

  # Set your time zone.
  time.timeZone = "Australia/Hobart";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  #environment.systemPackages = with pkgs; [
  #  wget vim
  #];

  #environment.systemPackages = 
  #  (import ./my-hello.nix) 
  # ; 


  # this will override the default to write blah to text file,
  # -- environment.root."inputrc".source = ./my-hello.nix;
  # environment.etc."inputrc".text = "blah blah blah";


#environment.systemPackages =
#  let
#    my-hello = with pkgs; stdenv.mkDerivation rec {
#      name = "hello-2.8";
#      src = fetchurl {
#        url = "mirror://gnu/hello/${name}.tar.gz";
#        sha256 = "0wqd8sjmxfskrflaxywc7gqw7sfawrfvdxd9skxawzfgyy0pzdz6";
#      };
#    };
#  in
#  with pkgs; [ vim wget screen python my-hello ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:


  services.hello = {
    enable = true;
    greeter = "Bob";
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "without-password";
  # JA usePAM is default
  # think would need the %u is user, %h is home /root/.ssh...
  # services.openssh.authorizedKeysFiles = ["%h/.ssh/authorized_keys"];
  # services.openssh.authorizedKeysFiles = ["~/.ssh/authorized_keys"];
  users.extraUsers.root.openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDd9DazuhCPLh9YcW8BtHTIWZ+k4ZXo7TtI55f2r/r1MXF/odbQsYb+lJmLMStp8ncHyH7YUaWBvWlz6q9ourkXixYuf255NjrVxBsnqWW58xPwtnRz7jVtVr2oBuId8Uf1o4HCou2a5vLRhuajq6Xd/VHz4z2kpcCsdObiteHqzrLCoZCtDlKxlcGADC057OqZM1FrIV1+2T5ZnN/PDwXphK0D+ZnHm2Sd5n0prpR4NfVtnlq3/68o5xzS2Wm4FhHXF2DqDzolC6OnPWHMqYNXn2vbmQD05Ef4iix0O8cYQ888QQ4/cUnW4ONPPCk1ixv8xqpXsLSAt8EdQjQsZRHB me" ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

}
