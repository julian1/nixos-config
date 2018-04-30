
# https://nixos.wiki/wiki/NixOS_Modules
# can see the service, here, though not sure where it exists in the filesystem
# systemctl cat hello.service 
# journalctl -e -u hello | tail


{ lib, pkgs, config, ... }:
with lib;                      
let
  cfg = config.services.hello;

  # this only gets created in the store
  configFile = with cfg; pkgs.writeText "hello.conf" ''
    log-file=/dev/stdout
    whoot whoot blah
  '';

in


  {
  options.services.hello = {
    enable = mkEnableOption "hello service";
    greeter = mkOption {
      type = types.string;
      default = "world";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.hello = {
    
      serviceConfig = {
          Type = "forking";
          #ExecStart = "${pkgs.hello}/bin/hello -g 'hi' ";

          # using the configFile forces it to evaluate, and generate a written file...
          ExecStart = "${pkgs.hello}/bin/hello -g ${configFile}";

          # ExecStop = "pkill ipfs";
          # Restart = "on-failure";
          User = "root";
          StandardOutput = "syslog+console" ;
          StandardError = "syslog+console";
      }; 
      wantedBy = [ "multi-user.target" ];

    };
  };
}




