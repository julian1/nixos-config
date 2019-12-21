
# ok. it is using the script.... because we can change the
# but its not compiling it...
# change branch to master - and it downloads a different version

# eg. it tries to download - master version.  rather than build the local source
#these derivations will be built:
#  /nix/store/n076vqcxdslhwfvz38zzsydi25iz2w3q-network-transport-tcp-master.tar.gz.drv


let
  config = rec {
    allowUnfree = true;
    allowBroken = true;
    packageOverrides = pkgs: rec {
      haskellPackages = pkgs.haskellPackages.override {
        overrides = haskellPackagesNew: haskellPackagesOld: rec {
          frontend =
     haskellPackagesNew.callPackage /home/me/nixos-config/nix/network-transport-tcp/shell.nix  {};
   };
      };
    };

    permittedInsecurePackages = [ "webkitgtk-2.4.11" ];
  };

  pkgs = import <nixpkgs> { inherit config; };

in
  { frontend = pkgs.haskellPackages.frontend; }


