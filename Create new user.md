# Create new user

## Prepare OS
```sh
sudo su
apt update && apt upgrade -y && sudo apt autoremove && apt install sudo
```
## Add new user and grant permissions
```sh
adduser medved
usermod -aG sudo medved

su medved
sudo chmod -R 777 $HOME
```
