/*
  eg.
  nix-shell  ~/nixos-config/examples/maven-and-java.nix
  cd freerouting
  mvn install
  export DISPLAY=:0
  java -jar target/freerouting-1.0.2-SNAPSHOT.jar

*/

with import <nixpkgs> {}; 

callPackage ({ stdenv, maven, makeWrapper, jdk, javaPackages, jq }: stdenv.mkDerivation {
 
  pname = "maven-and-java";
  version = "1.0.0";

  nativeBuildInputs = [ maven jdk  jq];   # needed
  buildInputs = [ jdk ];                # needed
} ) {} 




