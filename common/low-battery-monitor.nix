/*
  notes,
    script is named low-battery-check, but service is low-battery-alert
    journalctl -u low-battery-alert
    systemctl status low-battery-alert
    journalctl -u low-battery-alert -f

*/
{ lib,  pkgs, config, ... }:

with lib;

let
  low-battery-check = pkgs.writeShellScriptBin "low-battery-check" ''

    # looping version. without systemd timer which is too chatty in the logs

    beep() {
      #https://unix.stackexchange.com/questions/1974/how-do-i-make-my-pc-speaker-beep
      #speaker-test -t sine -f 1000 -l 1 & sleep .5 && kill -9 $! > /dev/null 2>&1
      speaker-test -t sine -f 1000 -l 1 > /dev/null & sleep .5 && kill -9 $!
    }

    run() {
      threshold=99
      capacity=$(cat /sys/class/power_supply/BAT0/capacity)
      status=$(cat /sys/class/power_supply/BAT0/status)

      # uncomment, for log progress
      # journalctl -f -u low-battery-alert
      echo "$(date) xxx whoami=$(whoami), status=$status, threshold=$threshold, capacity=$capacity"

      # beep if below threshold and not charging
      if [ $capacity -le $threshold ] && [ $status != "Charging" ] ; then

        # we are discharging and below threshold capacity
        # log this state only
        echo "$(date) xxx whoami=$(whoami), status=$status, threshold=$threshold, capacity=$capacity"
        echo "should beep"
        beep
      else
        # echo "no beep"
        true
      fi
    }


    while true; do
      run
      sleep 60
    done

  '';

 shell = "${pkgs.bash}/bin/bash";

in
{

  config.systemd.services.low-battery-alert = {

    wantedBy = [ "multi-user.target" ];

    after = [ "network.target" ];

    description = "Send alerts on low battery";

    serviceConfig = {
      Type = "simple";
      # IMPORTANT - user must be valid!!! needs to be able to connect to valid pulseaudio session.
      User = "me";
      ExecStart = ''
        ${shell} ${low-battery-check}/bin/low-battery-check
        '';
    };
 };

}
