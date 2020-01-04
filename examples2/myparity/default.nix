# copied from
# $ find ../large-nixpkgs/ | grep parity
# ../large-nixpkgs/pkgs/applications/blockchains/parity/default.nix


{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let
  version     = "2.5.13";
  sha256      = "0imfdjcg42jfnm897mgjyg0lj4dffsv44z74v0ilwqwqp9g9hwvx";
  cargoSha256 = "16nf6y0hyffwdhxn1w4ms4zycs5lkzir8sj6c2lgsabig057hb6z";  

  # ok. this now fails. perhaps because we want master branch? or something?
  # plug values in after it complains
  #version     = "2.5.12";
  #sha256      = "04b3nxfjqxk7imqizzrd7rcgpqjv5dn84cy1hlbxqn42r4q7f6i1";
  #cargoSha256 = "16nf6y0hyffwdhxn1w4ms4zycs5lkzir8sj6c2lgsabig057hb6z";  # wrong

  # version     = "2.5.11";
  #sha256      = "1x2p559g2f30520v3kn46n737l5s1kwrn962dv73s6mb6n1lhs55";
  #cargoSha256 = "16nf6y0hyffwdhxn1w4ms4zycs5lkzir8sj6c2lgsabig057hb6z";


in
  import ./parity.nix { inherit version sha256 cargoSha256; }
    (with nixpkgs; { inherit lib fetchFromGitHub rustPlatform cmake openssl pkgconfig systemd ; }) 


  

# ok.   it builds a shell but doesn't build???
# note that rustc and cargo etc. in scope...
# but where is the source?
# and how do we build the damn thing
