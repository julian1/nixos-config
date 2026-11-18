
set -e -x

cp nodes/zephyrus2.nix  /etc/nixos/configuration.nix ; 
nixos-rebuild  switch;

