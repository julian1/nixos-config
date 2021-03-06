# shell.nix
/*
  eg.
  $ nix-shell ~/nixos-config/examples/freerouting-shell.nix 
  $ freerouting
*/

with import <nixpkgs> {};

let
  sources = import ./freerouting-build.nix;
in

pkgs.mkShell {

  buildInputs = [
    # notice how mkShell interprets arguments,

    # if reference a binary, it will directly launch the binary
    #''${sources}/bin/freerouting''

    # else if referencing a derivation, it knows to look in ${sources}/bin and bring binaries into shell scope,
    ''${sources}''
  ];
}

