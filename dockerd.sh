#!/bin/bash

# setup docker env in wsl
if grep -q -i "microsoft" /proc/version; then
  sudo mkdir -p /sys/fs/cgroup/systemd
  sudo mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd

  sudo service docker start
fi
