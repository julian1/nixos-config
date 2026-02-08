/*
  notes,
    journalctl -u gitconfig-change
    systemctl status gitconfig-change
    journalctl -u gitconfig-change -f

*/
{ lib,  pkgs, config, ... }:

with lib;

let

  gitconfig-change = pkgs.writeShellScriptBin "gitconfig-change" ''

    run() {

      day=$( date '+%u')
      if [ $day = 6 ] || [ $day = 7 ] ; then
      # if false; then

        echo gitconfig-change yes ;
        sed -i 's/mail@julian1/git@julian1/'  /home/me/.config/git/config;
      else
        echo gitconfig-change no;
        sed -i 's/git@julian1/mail@julian1/'  /home/me/.config/git/config;
      fi
    }

    while true; do
      run
      sleep 3600
    done

  '';

 shell = "${pkgs.bash}/bin/bash";

in
{

  config.systemd.services.gitconfig-change = {

    wantedBy = [ "multi-user.target" ];

    after = [ "network.target" ];

    description = "update gitconfig";

    serviceConfig = {
      Type = "simple";
      # IMPORTANT - user must be valid!!!
      User = "me";
      ExecStart = ''
        ${shell} ${gitconfig-change}/bin/gitconfig-change
        '';
    };
 };

}
