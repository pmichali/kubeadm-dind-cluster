#!/bin/bash

set -x

# Force deletion of any existing Jool kernel modules
/sbin/modprobe -r jool
# Must delete files too!
find /lib/modules -name "jool*" -delete
vers=$(dkms status | grep jool | cut -f2 -d" " | cut -f1 -d",")
# Remove from DKMS
dkms remove jool/$vers --all

# Install the desired version
cd /usr/src && dkms install --verbose Jool

touch /init_done

# /sbin/modprobe jool pool6=fd00:7810:ffff::/96 disabled
# jool -4 --add 10.86.7.78 7000-8000
# jool --enable

while [ 1 ]; do
    sleep 1
done

