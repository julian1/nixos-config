
{ pkgs ? import <nixpkgs> {} }:
 with pkgs;

let
  x = 1 ;
  wrapped = pkgs.writeScriptBin "hello" ''
    !${pkgs.stdenv.shell}
    exec ${pkgs.hello}/bin/echo "hello"
    '';
in


pkgs.stdenv.mkDerivation {
  name = "my-example";


  buildInputs = [
     wrapped
  ];

}
