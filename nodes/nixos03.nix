# actually we don't want to sym link these. because they'll be different for every node
# unless create specific node.nix instances
{ config, pkgs, ... }:
{
    imports = [ <nixpkgs/nixos/modules/virtualisation/lxc-container.nix> ]
        ++ [ 

                /home/me/nixos-config/common/multi-glibc-locale-paths.nix 
                /home/me/nixos-config/common/basic19.nix   # note. v19
                /home/me/nixos-config/common/users.nix  
                /home/me/nixos-config/common/dotfiles.nix 
                /home/me/nixos-config/examples2/script-service.nix 
        ]; 



  networking.hostName = "nixos03";

  config.networking.firewall.enable = false;
}
