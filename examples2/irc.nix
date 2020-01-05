{ lib,  pkgs, ... }:
with lib;

{
  # This is pretty unbelievably good.
  # it's just a paragraph to define new custom service.
  # to login to the screen session. just 'screen -r irc'
  config.systemd.services.ircSession = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Start the irc client of username.";
      serviceConfig = {
        Type = "forking";
        # IMPORTANT - user must be valid!!!
        User = "me";
        ExecStart = ''${pkgs.screen}/bin/screen -dmS irc ${pkgs.irssi}/bin/irssi'';
        ExecStop = ''${pkgs.screen}/bin/screen -S irc -X quit'';
      };
   };

   config.environment.systemPackages = [ pkgs.screen ];
}


