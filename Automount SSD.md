# Automount SSD
```sh
sudo apt update && sudo apt upgrade -y && sudo apt autoremove
```
## Install exfat-fuse exfat-utils
```sh
sudo apt install exfat-fuse exfat-utils -y
```
## Config device UUID
```sh
sudo mkdir /data/storage
sudo chmod 777 /etc/fstab
UUID=$(blkid -o value -s UUID /dev/sda1)
```
```sh
sudo tee -a <<EOF >> /etc/fstab
UUID=$UUID       /data                         exfat   defaults,auto,umask=000,users,rw    0      0
/data/storage        /var/lib/rancher/k3s/storage  none    bind
EOF
```
```sh
sudo reboot
```
