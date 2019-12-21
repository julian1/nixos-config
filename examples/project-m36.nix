

# https://github.com/haskell-distributed/network-transport-tcp/
# https://stackoverflow.com/questions/27968909/how-to-get-cabal-and-nix-work-together

# overriding...
# https://github.com/Gabriel439/haskell-nix/tree/master/project4
# https://stackoverflow.com/questions/56414329/how-do-i-override-a-haskell-package-with-a-git-local-package-with-nix-when-usi
# https://old.reddit.com/r/NixOS/comments/ebgkub/need_help_trying_to_use_ghc_810_with_nix/

# to fix cd network-transport-tcp/
# follow this, to create a local nix package, and make adjustments to cabal
# https://nixos.org/nixpkgs/manual/#how-to-create-nix-builds-for-your-own-private-haskell-packages


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
          network-transport-tcp = (haskellPackagesNew.callPackage /home/me/nixos-config/nix/network-transport-tcp/shell.nix { });

          # test fail...  disable tests
          # rank1dynamic-0.4.0
          rank1dynamic = pkgs.haskell.lib.dontCheck  haskellPackagesOld.rank1dynamic;

          # distributed-process-0.7.4 also has the same issue... a dependency on containers ==0.5.*,
          # branch master has been updated, containers >= 0.5 && < 0.7,
          # no need to edit cabal. so perhaps we could have specified a master branch, rather than checking out source code
          distributed-process = (haskellPackagesNew.callPackage /home/me/nixos-config/nix/distributed-process/shell.nix { });


          #  stm-hamt-1.2.0.4
          # Setup: Encountered missing dependencies:
          # primitive ==0.7.*, primitive-extras ==0.8.*
          # we have, "primitive-0.7.0.0",   primitive-extras-0.7.1.1"
          #stm-hamt
          # so it should be ok.... maybe needs package deps regenerated 
          # https://hackage.haskell.org/package/stm-hamt
          # deleeted tests...
          stm-hamt = (haskellPackagesNew.callPackage /home/me/nixos-config/nix/stm-hamt/shell.nix { });

        };
      };
    };
  };

  pkgs = import <nixpkgs> { inherit config; };
in

pkgs.stdenv.mkDerivation {
  name = "my-example";

  buildInputs = [
    # pkgs.haskellPackages.network-transport-tcp

    # pkgs.haskellPackages.rank1dynamic
    pkgs.haskellPackages.primitive
    pkgs.haskellPackages.primitive-extras
    pkgs.haskellPackages.stm-hamt

    pkgs.haskellPackages.project-m36
  ];

}


# haskellPackages.hindent
#haskellPackages.project-m36

