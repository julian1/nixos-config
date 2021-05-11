# shell.nix
/*
  eg.
  $ nix-shell ~/nixos-config/examples/kicad-shell.nix 
  $ freerouting

  code taken from,
  https://github.com/NixOS/nixpkgs/pull/119986
*/

with import <nixpkgs> {};

let
  # sources = callPackage ./kicad.nix {};
  #sources = callPackage ./kicad/default.nix {};
  sources = callPackage ./evils-kicad/default.nix {};
in

pkgs.mkShell {

  buildInputs = [

    ''${sources}''
  ];
}



