
{ pkgs ? import <nixpkgs> {} }:
with pkgs;


pkgs.stdenv.mkDerivation rec {
  name = "parity";

  shellHook = ''figlet "Welcome! ${name}" | lolcat --freq 0.5'';

  buildInputs = [
    figlet
    lolcat
    parity
  ];
}

