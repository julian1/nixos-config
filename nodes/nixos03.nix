{ config, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/virtualisation/lxc-container.nix> ] ++
  [
    /home/me/nixos-config/common/multi-glibc-locale-paths.nix
    /home/me/nixos-config/common/locale19.nix   # note. v19
    /home/me/nixos-config/common/users.nix
    /home/me/nixos-config/common/dotfiles.nix
    /home/me/nixos-config/examples2/script-service.nix
    /home/me/nixos-config/examples2/irc.nix
  ];


  config.networking.hostName = "nixos03";

  config.networking.firewall.enable = false;

  # show ip address,
  config.services.mingetty.greetingLine = pkgs.lib.mkForce ''<<< \4, Welcome to NixOS, (\m) - \l >>>'';
}
