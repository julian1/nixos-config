# shell.nix
/*
  eg.
  $ nix-shell ~/nixos-config/examples/kicad-shell.nix 
  $ freerouting
*/

with import <nixpkgs> {};

let
  sources = callPackage ./kicad.nix {};
in

pkgs.mkShell {

  buildInputs = [

    ''${sources}''
  ];
}



