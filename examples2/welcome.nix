# eg. run as nix-shell ./welcome.nix

{ pkgs ? import <nixpkgs> {} }:
with pkgs;

pkgs.stdenv.mkDerivation {
  name = "my-example";

  shellHook = ''figlet "Welcome!" | lolcat --freq 0.5'';

  buildInputs = [
    figlet
    lolcat
  ];

}
