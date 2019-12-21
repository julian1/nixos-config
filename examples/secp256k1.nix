

let
  config = {

    # works to suppress refusal to build!!
    allowBroken = true;
    allowUnfree = true;

    packageOverrides = pkgs: rec {
      haskellPackages = pkgs.haskellPackages.override {
        overrides = haskellPackagesNew: haskellPackagesOld: rec {

          #ghc-shell-for-stm-hamt

        };
      };
    };
  };

  pkgs = import <nixpkgs> { inherit config; };
in

pkgs.stdenv.mkDerivation {
  name = "my-example";

  buildInputs = [
    
    pkgs.haskellPackages.secp256k1-haskell 

  ];

}


# haskellPackages.hindent
#haskellPackages.project-m36

