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
```
```sh
UUID=$(blkid -o value -s UUID /dev/sda1)

tee -a <<EOF > /etc/fstab > /dev/null
UUID=$UUID            /data                         exfat   defaults,auto,umask=000,users,rw    0       0" | sudo tee -a /etc/fstab > /dev/null
/data/storage         /var/lib/rancher/k3s/storage  none    bind 
EOF
#mount --bind source destination
 
#sudo echo "/data/storage         /var/lib/rancher/k3s/storage/ exfat   defaults,auto,umask=000,users,rw    0       0" | sudo tee -a /etc/fstab > /dev/null
```
