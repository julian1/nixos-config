# note that xeyes is now available to install as a package

# Nov 2020, AWS, works out of the box, over an ssh -Y session
# as long as X11 forwarding is configured in users.nix 

{ pkgs ? import <nixpkgs> {} }:
with pkgs;


# https://github.com/NixOS/nixpkgs/blob/1f51deb348d8009b864d40726a59f48624a9e52c/pkgs/servers/x11/xorg/default.nix
let
  xeyes = callPackage ({ stdenv, pkgconfig, fetchurl, libX11, libXext, libXmu, xorgproto, libXrender, libXt }: stdenv.mkDerivation {
    name = "xeyes-1.1.2";
    builder = ./X11-builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xeyes-1.1.2.tar.bz2";
      sha256 = "0lq5j7fryx1wn998jq6h3icz1h6pqrsbs3adskjzjyhn5l6yrg2p";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ libX11 libXext libXmu xorgproto libXrender libXt ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) {};

in

pkgs.stdenv.mkDerivation {
  name = "xeyes";

  shellHook = ''xeyes'';

  buildInputs = [
    xeyes
  ];

}
