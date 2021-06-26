
{ pkgs ? import <nixpkgs> {} }:
with pkgs;

# we don't need all the let bindings,
let
  x = 1 ;
  y = 2;
in


pkgs.stdenv.mkDerivation {
  name = "my-example";

  shellHook = ''figlet "Welcome!" | lolcat --freq 0.5'';

  buildInputs = [
    figlet
    lolcat

    # include gcc,g++, stdlib
    gcc9


    manpages

  ];

}
