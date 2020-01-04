# /etc/nixos/configuration should look something like this

{ modulesPath, lib, ... }:
{
  imports = lib.optional (builtins.pathExists ./do-userdata.nix) ./do-userdata.nix ++ [
    (modulesPath + "/virtualisation/digital-ocean-config.nix")
  ] 
        ++ [ 
            /home/me/nixos-config/common/basic20.nix   # note v20
            /home/me/nixos-config/common/keys.nix  
            /home/me/nixos-config/common/dotfiles.nix 
                
            /home/me/nixos-config/examples2/myparity/service.nix
        ] 
  ;

  networking.hostName = "dexter";
}


