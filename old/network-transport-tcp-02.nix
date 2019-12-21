

# https://github.com/haskell-distributed/network-transport-tcp/
# https://stackoverflow.com/questions/27968909/how-to-get-cabal-and-nix-work-together

# https://github.com/Gabriel439/haskell-nix/tree/master/project4
# https://stackoverflow.com/questions/56414329/how-do-i-override-a-haskell-package-with-a-git-local-package-with-nix-when-usi

# cd network-transport-tcp/
# cabal2nix network-transport-tcp.cabal 
# cabal2nix network-transport-tcp.cabal > shell.nix

# OK. I think the issue is that we expect the global packages under ./nix... not /nix

let
  config = {
    packageOverrides = pkgs: rec {
       haskellPackages = pkgs.haskellPackages.override {

        overrides = haskellPackagesNew: haskellPackagesOld:
          let
            toPackage = file: _: {
              name  = builtins.replaceStrings [ ".nix" ] [ "" ] file;
              value = haskellPackagesNew.callPackage (./. + "/nix/${file}") { };
            };
            packages = pkgs.lib.mapAttrs' toPackage (builtins.readDir ./nix);

          in
            packages // {
              network-transport-tcp = 
                pkgs.haskell.lib.dontCheck  
                  (haskellPackagesNew.callPackage nix/network-transport-tcp/shell.nix  { });
            };
        };
      };
    };

  # nothing seems to be getting overridden... even if it's reading my directories...
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

