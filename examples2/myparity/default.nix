# copied from
# $ find ../large-nixpkgs/ | grep parity
# ../large-nixpkgs/pkgs/applications/blockchains/parity/default.nix


{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let
  version     = "2.5.12";
  # plug values in after it complains
  sha256      = "04b3nxfjqxk7imqizzrd7rcgpqjv5dn84cy1hlbxqn42r4q7f6i1";
  cargoSha256 = "16nf6y0hyffwdhxn1w4ms4zycs5lkzir8sj6c2lgsabig057hb6z";  # wrong

  # version     = "2.5.11";
  #sha256      = "1x2p559g2f30520v3kn46n737l5s1kwrn962dv73s6mb6n1lhs55";
  #cargoSha256 = "16nf6y0hyffwdhxn1w4ms4zycs5lkzir8sj6c2lgsabig057hb6z";


 # lib fetchFromGitHub rustPlatform cmake openssl pkgconfig systemd


  x = import ./parity.nix { inherit version sha256 cargoSha256; }
    (with nixpkgs; { inherit lib fetchFromGitHub rustPlatform cmake openssl pkgconfig systemd ; })
    ;

in

# x has most of this stuff set. eg.  nativeBuildInputs, buildInputs  etc
# so why doesn't it build...

# see, https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/rust.section.md

nixpkgs. stdenv.mkDerivation {
  name = "rust-env";
  buildInputs = [
    # Example Run-time Additional Dependencies
    x
  ];

  # Set Environment Variables
  RUST_BACKTRACE = 1;
}


# ok.   it builds a shell but doesn't build???
# note that rustc and cargo etc. in scope...
# but where is the source?
# and how do we build the damn thing
