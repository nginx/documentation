#!/bin/bash
set -eux

if [ -f /etc/ssl/nginx-manager/ca.pem ] ; then
    if [ -d /etc/pki/ca-trust/source/anchors ]; then
        cp /etc/ssl/nginx-manager/ca.pem /etc/pki/ca-trust/source/anchors
        update-ca-trust
    elif [ -d /usr/local/share/ca-certificates ]; then
        cp /etc/ssl/nginx-manager/ca.pem /usr/local/share/ca-certificates
        update-ca-certificates
    fi
fi

if ! [ -d /sys/fs/cgroup/systemd ] ; then
    mkdir /sys/fs/cgroup/systemd
    mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd
fi

if [ -f /etc/systemd/system/multi-user.target.wants/nginx-debug.service ]; then
    rm /etc/systemd/system/multi-user.target.wants/nginx-debug.service
fi

echo "$HOSTNAME"

# Nothing below the exec line
exec "${COMPASS_SYSTEMD}"