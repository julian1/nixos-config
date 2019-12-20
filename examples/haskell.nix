

# https://github.com/haskell-distributed/network-transport-tcp/
# https://stackoverflow.com/questions/27968909/how-to-get-cabal-and-nix-work-together



let
  config = {
    packageOverrides = pkgs: rec {
      haskellPackages = pkgs.haskellPackages.override {
        overrides = haskellPackagesNew: haskellPackagesOld: rec {

         network-transport-tcp = haskellPackagesNew.callPackage /home/me/network-transport-tcp/shell.nix  { };

        };
      };
    };
  };

  pkgs = import <nixpkgs> { inherit config; };
in
with pkgs;


pkgs.stdenv.mkDerivation {
  name = "my-example";

  # why doesn't this work!!!.
  # pkgs.config.allowBroken = true;

  buildInputs = [
    cabal-install
    ghc
    # hoogle db written to $HOME/.hoogle. persists through nix-shell restarts
    haskellPackages.hoogle
    
    haskellPackages.network-transport-tcp

    # haskellPackages.idris
  ];

}


# haskellPackages.hindent
#haskellPackages.project-m36

