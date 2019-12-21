
{ pkgs ? import <nixpkgs> {} }:
with pkgs;


let
  x = 1 ;
in

# hoogle db written to $HOME/.hoogle. persists through nix-shell restarts

pkgs.stdenv.mkDerivation {
  name = "my-example";

  buildInputs = [
    cabal-install
    ghc
    haskellPackages.hoogle
    haskellPackages.cabal2nix

    # haskellPackages.hindent
    # haskellPackages.project-m36
    # haskellPackages.idris
  ];

}
