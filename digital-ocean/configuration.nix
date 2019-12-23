# /etc/nixos/configuration should look like this
{ modulesPath, lib, ... }:
{
  imports = lib.optional (builtins.pathExists ./do-userdata.nix) ./do-userdata.nix ++ [
    (modulesPath + "/virtualisation/digital-ocean-config.nix")

  # add our stuff to 
  ] ++ [ /home/me/nixos-config/digital-ocean/default.nix ] ;
}

