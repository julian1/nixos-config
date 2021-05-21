# shell.nix

# DONT USE. just run
# ./result/bin/freerouting
# after running,
# nix-build examples/freerouting-build.nix

DEPRECATED

/*
  eg.
  $ nix-shell ~/nixos-config/examples/freerouting-shell.nix
  $ freerouting

  IMPORTANT this is incorrectly organized.
  The callPackage() in freerouting-build should be here.

  see
    kicad-shell.nix for correct example,
  ref,
    https://stackoverflow.com/questions/44088192/when-and-how-should-default-nix-shell-nix-and-release-nix-be-used
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

