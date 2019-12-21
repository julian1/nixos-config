


# https://github.com/haskell-distributed/network-transport-tcp/
# https://stackoverflow.com/questions/27968909/how-to-get-cabal-and-nix-work-together

# overriding...
# https://github.com/Gabriel439/haskell-nix/tree/master/project4
# https://stackoverflow.com/questions/56414329/how-do-i-override-a-haskell-package-with-a-git-local-package-with-nix-when-usi
# https://old.reddit.com/r/NixOS/comments/ebgkub/need_help_trying_to_use_ghc_810_with_nix/
# https://old.reddit.com/r/NixOS/comments/99l24s/how_to_add_systemwide_local_haskell_packages/

# cd network-transport-tcp/
# cabal2nix network-transport-tcp.cabal 
# cabal2nix network-transport-tcp.cabal > shell.nix

# error: Package ‘network-transport-tcp-0.6.0’ in /nix/store/6h4axfcg417hnzz9zz967b78gy2m74mj-nixos-19.09.1647.2e73f72c87e/nixos/pkgs/development/haskell-modules/hackage-packages.nix:167665 is marked as broken, refusing to evaluate.


let

  config = {
    packageOverrides = pkgs: rec {
      haskellPackages = pkgs.haskellPackages.override {
       
        overrides = self: super: 
          let
            lib = super.haskell.lib;
            addPkg = path: rest: lib.dontCheck (lib.dontHaddock (self.haskellPackages.callPackage path rest));
          in {
              haskellPackages = super.haskellPackages.extend (hself: hsuper: {
                network-transport-tcp = addPkg ~/src/some-package1/default.nix {};
                some-package2 = addPkg ~/src/some-package2/default.nix {};
                });
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
