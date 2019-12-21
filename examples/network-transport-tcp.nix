

# https://github.com/haskell-distributed/network-transport-tcp/
# https://stackoverflow.com/questions/27968909/how-to-get-cabal-and-nix-work-together

# https://github.com/Gabriel439/haskell-nix/tree/master/project4
# https://stackoverflow.com/questions/56414329/how-do-i-override-a-haskell-package-with-a-git-local-package-with-nix-when-usi

# cd network-transport-tcp/
# cabal2nix network-transport-tcp.cabal 
# cabal2nix network-transport-tcp.cabal > shell.nix


let
  config = {
    packageOverrides = pkgs: rec {
      haskellPackages = pkgs.haskellPackages.override {
        overrides = haskellPackagesNew: haskellPackagesOld: rec {

          network-transport-tcp = 
            pkgs.haskell.lib.dontCheck  
              (haskellPackagesNew.callPackage ../network-transport-tcp/shell.nix  { });

        };
      };
    };
  };

  pkgs = import <nixpkgs> { inherit config; };
in
with pkgs;

  let network-transport-tcp  = pkgs.haskellPackages.network-transport-tcp;

  in

pkgs.stdenv.mkDerivation {
  name = "my-example";

  # why doesn't this work!!!.
  # pkgs.config.allowBroken = true;

  buildInputs = [
    cabal-install
    ghc
    # hoogle db written to $HOME/.hoogle. persists through nix-shell restarts
    haskellPackages.hoogle
    
    network-transport-tcp

    # haskellPackages.idris
  ];

}


# haskellPackages.hindent
#haskellPackages.project-m36

