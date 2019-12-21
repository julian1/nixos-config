
{ pkgs ? import <nixpkgs> {} }:
with pkgs;


let
  x = 1 ;
in

pkgs.stdenv.mkDerivation {
  name = "my-example";



  buildInputs = [
    cabal-install
    ghc
    # hoogle db written to $HOME/.hoogle. persists through nix-shell restarts
    haskellPackages.hoogle
    haskellPackages.cabal2nix

    # haskellPackages.hindent
    # haskellPackages.project-m36
    # haskellPackages.idris
  ];

}
