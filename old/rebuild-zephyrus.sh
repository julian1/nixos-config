
set -e

# apr 15 2023.
# commit 25e21b34a9d0916a764e0dc3dc853ba953aa5cbb (HEAD -> JA, origin/master, origin/HEAD, master)

# required for dumb python 2.7.
export NIXPKGS_ALLOW_INSECURE=1

nixos-rebuild -I nixpkgs=/home/me/devel/nixpkgs02/  -I  nixos-config=./nodes/zephyrus.nix     switch



# =============
# OLD.

# do a git checkout  of /homeme???

# nixpkgs
# 6e5f2d2b0105ae   jul 17. 2022.


# force tarball download after 60seconds instead of default 1hr.
# nixos-rebuild build --option tarball-ttl 60  -I nixpkgs=/home/me/devel/nixpkgs/  -I  nixos-config=./nodes/zephyrus.nix     switch


