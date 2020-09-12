
# doesn't seem to work.
# command not found

{ pkgs ? import <nixpkgs> {} }:
with pkgs;

let
  wrapped = pkgs.writeScriptBin "hello" ''
    !${pkgs.stdenv.shell}
    exec ${pkgs.hello}/bin/hello -t
    '';

in
wrapped


