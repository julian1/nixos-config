
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
    manpages    

    # gcc-arm-embedded-9-2019-q4-major    jun 8, 2021
    gcc-arm-embedded
    
    # libopencm3 uses pythong to do something. 
    python3

    # openocd-0.10.0    jun 8, 2021. 
    openocd
    rlwrap
    # nc comes from somewherei 
    netcat
  ];

}
