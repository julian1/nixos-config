
# branch master.
# nix-build  -I nixpkgs=/home/me/large-nixpkgs/  '<nixpkgs/nixos>' --arg configuration ./default.nix -A config.system.build.digitalOceanImage

{
  imports = [
    <nixpkgs/nixos/modules/virtualisation/digital-ocean-image.nix>
          #./nixos/modules/virtualisation/digital-ocean-image.nix
  ];
}


