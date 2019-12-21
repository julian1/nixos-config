

# https://github.com/haskell-distributed/network-transport-tcp/
# https://stackoverflow.com/questions/27968909/how-to-get-cabal-and-nix-work-together

# overriding...
# https://github.com/Gabriel439/haskell-nix/tree/master/project4
# https://stackoverflow.com/questions/56414329/how-do-i-override-a-haskell-package-with-a-git-local-package-with-nix-when-usi
# https://old.reddit.com/r/NixOS/comments/ebgkub/need_help_trying_to_use_ghc_810_with_nix/

# cd network-transport-tcp/
# cabal2nix network-transport-tcp.cabal 
# cabal2nix network-transport-tcp.cabal > shell.nix


let
  config = {

    # works to suppress refusal to build!!
    allowBroken = true;
    allowUnfree = true;

    packageOverrides = pkgs: rec {
      haskellPackages = pkgs.haskellPackages.override {
        overrides = haskellPackagesNew: haskellPackagesOld: rec {

          network-transport-tcp = 
            #pkgs.haskell.lib.dontCheck  
              (haskellPackagesNew.callPackage /home/me/nixos-config/nix/network-transport-tcp/shell.nix { });
        };
      };
    };
  };

  # nixpkgs = import ./nixpkgs.nix;
  pkgs = import <nixpkgs> { inherit config; };
in
with pkgs;

pkgs.stdenv.mkDerivation {
  name = "my-example";

  buildInputs = [
    cabal-install
    ghc
    haskellPackages.network-transport-tcp
  ];

}


# haskellPackages.hindent
#haskellPackages.project-m36

