#/bin/bash
set -ex

mkdir -p /etc/polipo
cat > /etc/polipo/config <<EOF
logSyslog = true
logFile = /var/log/polipo/polipo.log
disableIndexing = false
disableServersList = false
proxyAddress = "0.0.0.0"    # IPv4 only
allowedClients = 127.0.0.1, 192.168.1.0/24, 192.168.122.0/24, 172.18.161.0/24 # libvirt VMs
objectHighMark = 131072
diskCacheTruncateTime = 30d
diskCacheUnlinkTime = 30d
relaxTransparency = true      #cache everything
proxyOffline = false          #change to true to be offline
EOF

cat > /etc/network/interfaces.d/ens7.cfg <<EOF
auto ens7
iface ens7 inet dhcp
EOF

ifup ens7

DEBIAN_FRONTEND=noninteractive sudo apt-get -qqy update
DEBIAN_FRONTEND=noninteractive sudo apt-get install -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -qqy \
  polipo bmon

service polipo restart
sudo route add -net 10.0.0.0 gw 172.18.161.6 netmask 255.255.255.0
