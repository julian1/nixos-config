/*

  nix-shell  ~/nixos-config/examples/maven-and-java.nix
  cd freerouting
  mvn install

*/

with import <nixpkgs> {}; 

callPackage ({ stdenv,   maven, makeWrapper,  jdk,  javaPackages  }: stdenv.mkDerivation {
 
  pname = "maven-and-java";
  version = "1.0.0";

  nativeBuildInputs = [ maven jdk ];   # needed
  buildInputs = [ jdk ];                # needed
} ) {} 




