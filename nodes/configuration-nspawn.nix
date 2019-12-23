# actually we don't want to sym link these. because they'll be different for every node
# unless create a node.nix instance.
{ config, pkgs, ... }:
{
    imports = [ <nixpkgs/nixos/modules/virtualisation/lxc-container.nix> ]
        ++ [ 

                /home/me/nixos-config/common/multi-glibc-locale-paths.nix 
                /home/me/nixos-config/common/basic19.nix   # note. v19
                /home/me/nixos-config/common/keys.nix  
                /home/me/nixos-config/common/dotfiles.nix 
        ]; 
}
