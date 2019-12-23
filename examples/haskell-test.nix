

let
  config = {

    # works to suppress refusal to build!!
    allowBroken = true;
    allowUnfree = true;

    packageOverrides = pkgs: rec {
      haskellPackages = pkgs.haskellPackages.override {
        overrides = haskellPackagesNew: haskellPackagesOld: rec {

          # network-transport-tcp-0.6.0 has a dependency on old version of containers
          # master branch relaxes version
          # also need to remove tests which are in a separate module from cabal file
          network-transport-tcp = (haskellPackagesNew.callPackage /home/me/nixos-config/nix/network-transport-tcp/default.nix { });

        };
      };
    };
  };

  pkgs = import <nixpkgs> { inherit config; };
in

pkgs.stdenv.mkDerivation {
  name = "my-example";

  buildInputs = [

    #pkgs.haskellPackages.primitive
    #pkgs.haskellPackages.primitive-extras

    #pkgs.haskellPackages.rank1dynamic
    #pkgs.haskellPackages.stm-hamt
    #pkgs.haskellPackages.distributed-process-client-server
    
    #pkgs.haskellPackages.stm-containers

    # pkgs.haskellPackages.project-m36
    pkgs.cabal-install
    pkgs.ghc

    pkgs.haskellPackages.network-transport-tcp
  ];

}


# haskellPackages.hindent
#haskellPackages.project-m36

