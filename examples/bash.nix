
{ pkgs ? import <nixpkgs> {} }:
with pkgs;

let myBash = pkgs.symlinkJoin {
  name = "bash";
  buildInputs = [makeWrapper];
  paths = [ bash ];
  postBuild =
    ''
    wrapProgram "$out/bin/bash" --add-flags "--rcfile ./dotfiles/bashrc"
    '';
};
in


pkgs.mkShell {
  name = "swift-env";

  buildInputs = with pkgs; [
    myBash 
  ];

  shellHook = ''
    CC=clang
  '';
}

# shellHook can actually choose to replace bash with eg. screen .... 

# what's the difference between mkShell and mkDerivation ???

#stdenv.mkDerivation {
#  name = "my-example";
#
#  buildInputs = [
#    myBash
#  ];
#
#}



