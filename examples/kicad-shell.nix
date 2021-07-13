# shell.nix

DEPRECATED
use this instead,

nix-shell -p kicad  -I nixpkgs=/home/me/devel/nixpkgs/

  commit 5e9429689a988bac273a98b3f85cb71d1aa15eb0 (HEAD -> master, origin/master, origin/HEAD)
  Date:   Wed Jul 14 00:53:20 2021 +0200

pulls kicad, 5.1.10

Application: Eeschema
Version: 5.1.10, release build
Libraries:
    wxWidgets 3.0.5
    libcurl/7.76.1 OpenSSL/1.1.1k zlib/1.2.11 brotli/1.0.9 libssh2/1.9.0 nghttp2/1.43.0
Platform: Linux 5.11.22 x86_64, 64 bit, Little endian, wxGTK


/*
  eg.
  $ nix-shell ~/nixos-config/examples/kicad-shell.nix 


  nix-shell ~/devel/nixos-config/examples/kicad-shell.nix -I nixpkgs=/home/me/devel/nixpkgs/

  commit 5e9429689a988bac273a98b3f85cb71d1aa15eb0 (HEAD -> master, origin/master, origin/HEAD)
  Date:   Wed Jul 14 00:53:20 2021 +0200

  $ freerouting

  code taken from,
  https://github.com/NixOS/nixpkgs/pull/119986
*/

with import <nixpkgs> {};

let
  # sources = callPackage ./kicad.nix {};
  #sources = callPackage ./kicad/default.nix {};
  sources = callPackage ./evils-kicad/default.nix {};
in

pkgs.mkShell {

  buildInputs = [

    ''${sources}''
  ];
}



