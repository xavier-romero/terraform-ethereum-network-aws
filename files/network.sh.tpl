#!/bin/bash
MOUNT_DEV=/dev/md0
MOUNT_ETH=/mnt/ethereum

DEBIAN_FRONTEND=noninteractive apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y git

timedatectl set-timezone Europe/Madrid

mdadm -C $MOUNT_DEV -l raid0 -n 2 /dev/nvme1n1 /dev/nvme2n1
mkfs.xfs $MOUNT_DEV
mkdir $MOUNT_ETH

if ! $(grep -q $MOUNT_ETH /etc/fstab); then
    echo "$MOUNT_DEV $MOUNT_ETH xfs  defaults  0 0" | tee -a /etc/fstab
fi
which mountpoint && mountpoint $MOUNT_ETH || sudo mount $MOUNT_ETH

cd /tmp
wget https://github.com/sigp/lighthouse/releases/download/v3.4.0-tree.1/lighthouse-v3.4.0-tree.1-x86_64-unknown-linux-gnu.tar.gz
tar xvzf lighthouse-v3.4.0-tree.1-x86_64-unknown-linux-gnu.tar.gz 
mv lighthouse /usr/local/bin/
