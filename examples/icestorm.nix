
{ pkgs ? import <nixpkgs> {} }:
with pkgs;


pkgs.stdenv.mkDerivation {
  name = "my-example";

  shellHook = ''figlet "Icestorm!" | lolcat --freq 0.5'';

  buildInputs = [
    figlet
    lolcat

    yosys
    arachne-pnr
    icestorm
  ];

}
