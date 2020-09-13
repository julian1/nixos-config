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
    # if it's a binary, then it will directly launch the binary
    #''${sources}/bin/freerouting''

    # else if referencing a derivation, it will bring the binaries from ${sources}/bin into shell scope,
    ''${sources}''
  ];
}

