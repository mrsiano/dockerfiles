#!/bin/bash

if [ -d /proc_host ]; then
  umount /proc
  mount -o bind /proc_host /proc
fi
systemctl restart collectd
while true; do sleep 1; done
