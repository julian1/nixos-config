/*
  nix-shell  ~/devel/nixos-config/examples/arm.nix  -I nixpkgs=/home/me/devel/nixpkgs/

  https://nixos.wiki/wiki/Cross_Compiling
  https://rzetterberg.github.io/teensy-development-on-nixos.html


*/

{ pkgs ? import <nixpkgs> {} }:
with pkgs;

pkgs.stdenv.mkDerivation {
  name = "my-example";

  shellHook = ''figlet "Welcome!" | lolcat --freq 0.5'';

  buildInputs = [
    figlet
    lolcat

    gnumake

    # man memcpy, sprintf etc
    # manpages
    man-pages    # rename jun 2022.

    # gcc-arm-embedded-9-2019-q4-major    jun 8, 2021
    gcc-arm-embedded

    # libopencm3 uses pythong to do something.
    python3

    # openocd-0.10.0    jun 8, 2021.
    openocd

    # for both picocom and nc
    rlwrap

    # nc comes from somewherei  to connect to openocd port
    # think this is traditional
    netcat

    # alternative to netcat, to connect to uart
    picocom

    # ncurses or ncurses-dev ??? compiled under arm?
  ];

}
