# Automount SSD
## Install exfat-fuse exfat-utils
```sh
sudo apt install exfat-fuse exfat-utils -y
```
## Config device UUID
```sh
sudo mkdir /data
UUID=$(blkid -o value -s UUID /dev/sda1)
sudo echo "UUID=$UUID        /data           exfat   defaults,auto,umask=000,users,rw    0       0" | sudo tee -a /etc/fstab > /dev/null
```
