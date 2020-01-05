# eg.
# ln -sf /home/me/nixos-config/nspawn/configuration.nix  /etc/nixos/configuration.nix

{ lib,  pkgs, ... }:
with lib;

{
  imports = [ <nixpkgs/nixos/modules/virtualisation/lxc-container.nix> ];


  # https://www.reddit.com/r/NixOS/comments/7e4yke/modify_etcinputrc_or_any_other_system_file/

  # nixpkgs.config.allowBroken = true;

  # ok this actually installs the ipfs binary.
  # but how do we write a new service...

  # services are here...

#  config.systemd.services.ipfs-daemon  = {
#    description = "IPFS Daemon";
#    serviceConfig = {
#      Type = "forking";
#      ExecStart = "${pkgs.ipfs}/bin/ipfs daemon";
#      ExecStop = "pkill ipfs";
#      Restart = "on-failure";
#    };
#    wantedBy = [ "default.target" ];
#  };

# systemd.services.ipfs-daemon.enable = true;

  # This is pretty unbelievably good.
  # it's just a paragraph to define new custom service.
  # to login to the screen session. just 'screen -r irc'
  config.systemd.services.ircSession = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Start the irc client of username.";
      serviceConfig = {
        Type = "forking";
        # IMPORTANT - must ve valid!!!
        User = "me";
        ExecStart = ''${pkgs.screen}/bin/screen -dmS irc ${pkgs.irssi}/bin/irssi'';
        ExecStop = ''${pkgs.screen}/bin/screen -S irc -X quit'';
      };
   };

   config.environment.systemPackages = [ pkgs.screen ];


}

