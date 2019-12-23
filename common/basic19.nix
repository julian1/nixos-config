{ lib,  pkgs, ... }:
with lib;
{

  # hostname and firewall probably belong elsewhere
  # config.networking.hostName = "nixos03"; # Define your hostname.

  # Note, this is already set in keys.nix
  # config.networking.firewall.enable = false;

  ############

  # Select internationalisation properties.
  config.i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    # doesn't seem to honor this
    defaultLocale = "en_US.UTF-8";
    # defaultLocale = "en_AU.UTF-8";
  };


  # Set your time zone.
  # config.time.timeZone = "Australia/Hobart";
  config.time.timeZone = "Asia/Ho_Chi_Minh";

}


