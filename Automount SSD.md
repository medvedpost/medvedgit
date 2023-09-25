# Automount SSD
```sh
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
```
## Install exfat-fuse exfat-utils
```sh
sudo apt install exfat-fuse exfat-utils -y
```
## Config device UUID
```sh
sudo mkdir /data
sudo chmod 777 -R /data
sudo mkdir -p /var/lib/rancher/k3s/storage
sudo chmod 777 -R /var/lib/rancher/k3s/storage
sudo chmod 777 /etc/fstab
UUID=$(blkid -o value -s UUID /dev/sda)
```
```sh
sudo tee -a <<EOF >> /etc/fstab
#UUID=$UUID               /var/lib/rancher/k3s/storage exfat   defaults,auto,umask=000,users,rw    0      0
UUID=$UUID               /var/lib/rancher/k3s/storage exfat   rw,relatime    0      0
/var/lib/rancher/k3s/storage /data                        none    bind
EOF
```
```sh
sudo reboot
```
