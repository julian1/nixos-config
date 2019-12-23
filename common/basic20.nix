{ lib,  pkgs, ... }:
with lib;
{

  # Select internationalisation properties.
  config.i18n = {
    #consoleFont = "Lat2-Terminus16";
    #consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    # defaultLocale = "en_AU.UTF-8";
  };

  # nixos v20
  config.console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Set your time zone.
  config.time.timeZone = "Australia/Hobart";
}


