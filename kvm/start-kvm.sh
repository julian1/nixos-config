#!/bin/bash

# assumes bridge br0 is configured,
# apt-get install qemu-system-x86-64

IMAGE=images/myimage.qcow
PID=$$
MAC='00:01:04:1b:2C:1B'


echo "mac is $MAC"

#  -cdrom nixos-minimal-18.03.132155.b50443b5c4a-x86_64-linux.iso \

qemu-system-x86_64 \
  -enable-kvm \
  -drive file=./$IMAGE \
  -boot order=d \
  -m 2G \
  -nographic \
  -net nic,macaddr="$MAC" \
  -net tap,ifname=mybr$PID


# console out
#  -nographic \


