
{ pkgs ? import <nixpkgs> {} }:
with pkgs;

# this works...
# eg. cat result/bin/bash
# shows that it adds the dotfiles. but the path is no good.
# would need to copy dotfiles into the store somehow

let myBash = pkgs.symlinkJoin {
  name = "whoot";
  buildInputs = [makeWrapper];
  paths = [ bash ];
  postBuild =
    ''
    wrapProgram "$out/bin/bash" --add-flags "--rcfile ./dotfiles/bashrc"
    '';
};

in
myBash

