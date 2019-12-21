
let
  config = {

    allowBroken = true;

    packageOverrides = pkgs: rec {
      haskellPackages = pkgs.haskellPackages.override {
        overrides = haskellPackagesNew: haskellPackagesOld: rec {


          # tests are a separate project... so we have to edit the underlying cabal file.       
          project4 = 
              (haskellPackagesNew.callPackage /home/me/nixos-config/nix/network-transport-tcp/shell.nix { });
 

        };
      };
    };
  };

  pkgs = import <nixpkgs> { inherit config; };

in
  { project4 = pkgs.haskellPackages.project4;
  }

