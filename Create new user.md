# Create new user

## Prepare OS
```sh
apt update | dsd
apt upgrade
apt install sudo
```
## Add new user and grant permissions
```sh
adduser medved
usermod -aG sudo medved

su medved
sudo chmod -R 777 $HOME
```
