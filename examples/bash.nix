
{ pkgs ? import <nixpkgs> {} }:
with pkgs;

# this works...
# eg. cat result/bin/bash
# shows that it adds the dotfiles. but the path is no good.
# would need to copy dotfiles into the store somehow


let 

#file = builtins.readFile ( ../dotfiles/bashrc );

myBash = pkgs.symlinkJoin {
  name = "whoot";
  buildInputs = [makeWrapper];
  paths = [ bash ];
  postBuild =
    ''
    wrapProgram "$out/bin/bash" --add-flags "--rcfile ${../dotfiles/bashrc}"

    '';

    #wrapProgram "$out/bin/bash" --add-flags "--rcfile ${file}"
    #wrapProgram "$out/bin/bash" --add-flags "--rcfile ./dotfiles/bashrc"
};

in
myBash

