#!/bin/bash

if [ -d /proc_host ]; then
  umount /proc
  mount -o bind /proc_host /proc
fi

#sed -i "/graphite_host/c \ \ \ \ Host ${graphite_host}" /etc/collectd.conf
#sed -i "/graphite_prefix/c \ \ \ \ Host ${graphite_prefix}" /etc/collectd.conf

# run collectd
/usr/sbin/collectd -f
