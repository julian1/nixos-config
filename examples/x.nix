
# mkDerivation
# referring to other derivations. has to be with ${pkgs.xxx} where we modify pkgs...
# seems complicated.

{ pkgs ? import <nixpkgs> {} }:
 with pkgs;

# ok just unpacking a tarballl should be a funtion... 
# but maybe it can be a derivation...


let

myWrapped = pkgs.stdenv.mkDerivation {
  name = "my-example";


  buildInputs = [ ];

  #src = "./y.nix";
  #src = "./y.tgz";
  #src = "y.tgz";
  #srcs = "y.tgz";
  #src = "./y.tgz";
  src = "/home/me/nixos-config/examples/y.nix";



  # standard derivation expects a src
  #src = fetchurl {
  #    # url = "http://pandanet-igs.com/gopanda2/installer/stable/linux-64/gopanda2-linux-64.tar.gz";
  #    url = "file://y.nix";
  #    sha256 = "6d0a13e81a4646779331ff182acdbf9fe7982b2659f12a794a50897ea7368e1c";
  #};

  # srcs = (builtins.fromJSON (builtins.readFile ./src-deps.json));
  #srcs = builtins.readFile ./y.nix;

};


in

myWrapped

/*
pkgs.stdenv.mkDerivation {
  name = "my-example";

  # standard derivation expects a src
  src = "$myWrapped";

  buildInputs = [
     myWrapped
  ];

}
*/
