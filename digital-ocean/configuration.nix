# /etc/nixos/configuration should look something like this

{ modulesPath, lib, ... }:
{
  imports = lib.optional (builtins.pathExists ./do-userdata.nix) ./do-userdata.nix ++ [
    (modulesPath + "/virtualisation/digital-ocean-config.nix")
  ] 
    ++ [ 
    /home/me/nixos-config/digital-ocean/keys.nix  
    /home/me/nixos-config/digital-ocean/dotfiles.nix 
  ];
}


