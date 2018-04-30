
{ pkgs ? import <nixpkgs> {} }:
with pkgs;




#let myBash = {
#  # config.programs.bash.interactiveShellInit = ''whoot=ls'';
#
#  # environment.etc."bashrc".text = mkForce ''whoot=ls'';
#};
#in

let
  wrapped = pkgs.writeScriptBin "hello" ''
    !${pkgs.stdenv.shell}
    exec ${pkgs.hello}/bin/hello -t
    '';

in


stdenv.mkDerivation {
  name = "my-example";


  buildInputs = [
    wrapped 
  ];

}

