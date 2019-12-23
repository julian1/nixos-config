# /etc/nixos/configuration should look something like this

{ modulesPath, lib, ... }:
{
  imports = lib.optional (builtins.pathExists ./do-userdata.nix) ./do-userdata.nix ++ [
    (modulesPath + "/virtualisation/digital-ocean-config.nix")
  ] 
        ++ [ 
                /home/me/nixos-config/common/basic20.nix  
                /home/me/nixos-config/common/keys.nix  
                /home/me/nixos-config/common/dotfiles.nix 
        ] 
  ;
}


