#!/bin/bash

# can do the injection thing - with network/interfaces or ssh keys or whatever...


# test, for various stuff..
# has bunch of old crap should delete

# path=./my-nixos-17.09
path=./my-nixos-18.03


# nixos symlinks os-release on boot
rm    $path/etc/os-release
touch $path/etc/os-release

systemd-nspawn \
  -D "$path" \
  --boot \
  --network-bridge=br0 -n \


#  -D "/var/lib/machines/my-nixos" \
