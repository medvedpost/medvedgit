# Prepare Raspberry Pi

```bash
date +"%Y.%m.%d"
```
<pre>
2024.01.19

Raspberry Pi OS (Legacy, 64-bit) Lite
A port of Debian Bullseye with security updates and no desktop environment
Released: 2023-12-05 Cached on your computer
</pre>
```bash
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
```
### Install Mate GUI & enable VNC
```bash
sudo apt install mate-desktop-environment-extras -y
sudo apt install lightdm
sudo raspi-config
```
`System Options` > `Boot / Auto Login` > `Desktop Autologin`
`Interface Options` > `VNC` > `Yes`
### Mount SSD
```bash
sudo mkdir /data
sudo chmod 777 -R /data
sudo cp /etc/fstab /etc/fstab.bak
sudo chmod 777 /etc/fstab
sudo blkid
```
```
sudo nano /etc/fstab
```
<pre>
proc                  /proc           proc    defaults          0  0
PARTUUID=dc0f2163-01  /boot           vfat    defaults          0  2
PARTUUID=dc0f2163-02  /               ext4    defaults,noatime  0  1
/dev/sda1             /data           ext4    defaults,noatime  0  1
</pre>

### Preconfigure k3s folder & create symblic links
```bash
sudo mkdir -p /data/k3s/pods /data/k3s/rancher /var/lib/kubelet/ 

sudo ln -s /data/k3s/         /run/k3s
sudo ln -s /data/k3s/pods     /var/lib/kubelet/pods
sudo ln -s /data/k3s/rancher/ /var/lib/rancher
```
### Install OpenVPN & start client

```bash
sudo apt install openvpn -y
sudo cp Pi4B-vpn.conf /etc/openvpn/

sudo systemctl start openvpn@Pi4B-vpn
sudo systemctl status openvpn@Pi4B-vpn
sudo systemctl enable openvpn@Pi4B-vpn
```
```bash
cat /etc/openvpn/Pi4B-vpn.conf
```
<pre>
client
proto udp
;dev tun
dev tap
remote 195.2.75.173 1194
resolv-retry infinite
nobind
user nobody
group nogroup
persist-key
persist-tun
remote-cert-tls server
tls-auth ta.key 1
cipher AES-128-CBC
auth SHA256
verb 3
key-direction 1
[...]
</pre>
```bash
ifconfig
```
<pre>
tap0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.3.3.4  netmask 255.255.255.0  broadcast 0.0.0.0
        inet6 fe80::88ff:faff:fed9:f980  prefixlen 64  scopeid 0x20<link>
        ether 8a:ff:fa:d9:f9:80  txqueuelen 1000  (Ethernet)
        RX packets 10  bytes 488 (488.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 71  bytes 7463 (7.2 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
</pre>


### Configure /etc/hosts
```bash
sudo nano /etc/hosts
```
<pre>
127.0.0.1    localhost
#::1         localhost ip6-localhost ip6-loopback
#ff02::1     ip6-allnodes
#ff02::2     ip6-allrouters
127.0.1.1    medvedcloud medvedcloud.lan medvedcloud.local medvedcloud.duckdns.org
</pre>

### Start reconnect-wifi.sh
```bash
chmod +x /home/medved/reconnect-wifi.sh
```
<pre>
# Check the connectivity
if ! ping -c2 8.8.8.8 > /dev/null; then
       ifconfig wlan0 down
        sleep 2
       ifconfig wlan0 up
        sleep 10
        systemctl restart ssh
fi
</pre>
```bash
crontab -e
```
<pre>
*/1 * * * * /home/medved/reconnect-wifi.sh
</pre>
```bash
sudo reboot
```
