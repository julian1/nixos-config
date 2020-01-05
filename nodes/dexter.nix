# /etc/nixos/configuration should look something like this
# change name of this node file to dexter...

{ modulesPath, lib, ... }:
{


  imports = lib.optional (builtins.pathExists ./do-userdata.nix) ./do-userdata.nix ++ [
    (modulesPath + "/virtualisation/digital-ocean-config.nix")
  ]
    ++ [
        /home/me/nixos-config/common/basic20.nix   # note v20
        /home/me/nixos-config/common/keys.nix
        /home/me/nixos-config/common/keys2.nix
        /home/me/nixos-config/common/dotfiles.nix
        /home/me/nixos-config/examples2/myparity/service.nix
    ]
  ;


  config.networking.hostName = "dexter";

  config.networking.firewall.enable = false;

  config.services.parity.listenAddress  = "206.189.42.212";
}


