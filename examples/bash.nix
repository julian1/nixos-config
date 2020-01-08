
{ pkgs ? import <nixpkgs> {} }:
with pkgs;

# OK. this works...
# it copies ../dotfiles/bashrc into the store 
# can verify


pkgs.symlinkJoin {
  name = "whoot";
  buildInputs = [makeWrapper];
  paths = [ bash ];
  postBuild =
    ''
    wrapProgram "$out/bin/bash" --add-flags "--rcfile ${../dotfiles/bashrc}"

    '';
}


