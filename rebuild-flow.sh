
set -e -x

cp nodes/flow.nix  /etc/nixos/configuration.nix ; 
nixos-rebuild  switch;

