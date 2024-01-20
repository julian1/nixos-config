
{ pkgs ? import <nixpkgs> {} }:
with pkgs;


pkgs.stdenv.mkDerivation {
  name = "my-example";

  shellHook = ''figlet "Welcome!" | lolcat --freq 0.5'';

  buildInputs = [
    figlet
    lolcat

    # include gcc,g++, stdlib
    gcc9
    man-pages


    
    # add ncurses headers and lib to scope
    # eg. gcc main11.c  -lncurses
    ncurses
  ];


}
