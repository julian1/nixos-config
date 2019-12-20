
{ pkgs ? import <nixpkgs> {} }:
with pkgs;


let
  x = 1 ;
  wrapped = pkgs.writeScriptBin "hello" ''
    !${pkgs.stdenv.shell}
    exec ${pkgs.hello}/bin/hello -t
    '';
in


stdenv.mkDerivation {
  name = "my-example";

  buildInputs = [
    cabal-install
    ghc
    # hoogle db written to $HOME/.hoogle. persists through nix-shell
    haskellPackages.hoogle
  ];

}
