
nixos-rebuild build   -I nixpkgs=/home/me/devel/nixpkgs/  -I  nixos-config=./nodes/zephyrus.nix     switch

# force tarball download after 60seconds instead of default 1hr.
# nixos-rebuild build --option tarball-ttl 60  -I nixpkgs=/home/me/devel/nixpkgs/  -I  nixos-config=./nodes/zephyrus.nix     switch


