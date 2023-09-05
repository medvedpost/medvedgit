# medvedgit
```console
sudo apt update && sudo apt upgrade
```

#### Create new sudo users and switch on it
```console
apt install sudo
adduser medved
usermod -aG sudo medved
su medved
```

#### [Automount SSD](https://pimylifeup.com/raspberry-pi-exfat/)
```console
sudo apt install exfat-fuse exfat-utils -y
```
```console
UUID=$(blkid -o value -s UUID /dev/sda1)
sudo echo "UUID=$UUID        /data           exfat   defaults,auto,umask=000,users,rw    0       0" | sudo tee -a /etc/fstab > /dev/null
```

#### [Generating public/private rsa key pair](https://andreyex.ru/linux/kak-dobavit-otkrytyj-klyuch-ssh-na-server/)
```console
mkdir /home/medved/.ssh/
sudo ssh-keygen -t rsa -f /home/medved/.ssh/id_rsa
cp ~/.ssh/id_rsa.pub  ~/.ssh/authorized_keys
```
```console
if [ -z "$(sudo grep 'medved ALL=(ALL:ALL) ALL' /etc/sudoers )" ]
  then echo "medved ALL=(ALL:ALL) ALL" | sudo EDITOR='tee -a' visudo;
fi;
#sudo visudo
```

#### [Install OS dependencies](https://github.com/philschatz/nextcloud-kubernetes-pi/blob/main/templates/install-os-deps.sh)
```console
sudo apt install git pmount downtimed unattended-upgrades curl net-tools -y
```
#### [Install packages that reduce the churn on the SD card](https://github.com/philschatz/nextcloud-kubernetes-pi/blob/main/templates/install-disk-savers.sh)
Install zram-swap if it is not already running
```console
systemctl -q is-active zram-swap || {
  [[ -d ./zram-swap ]] && rm -r ./zram-swap

  git clone https://github.com/foundObjects/zram-swap.git
  pushd ./zram-swap
  sudo ./install.sh
  popd
  rm -r ./zram-swap
};
```
```console
systemctl status zram-swap
```
Install log2ram if it is not already running
```console
systemctl -q is-active log2ram || {
  [[ -d ./log2ram-master ]] && rm -r ./log2ram-master 

  curl -Lo log2ram.tar.gz https://github.com/azlux/log2ram/archive/master.tar.gz
  tar xf log2ram.tar.gz
  pushd ./log2ram-master
  chmod +x install.sh && sudo ./install.sh
  popd
  rm -r ./log2ram-master

  echo "SystemMaxUse=20M" | sudo tee -a /etc/systemd/journald.conf > /dev/null
};
```
```console
sudo systemctl reboot
```
#### [Install local helpers (k3sup)](https://github.com/alexellis/k3sup)
```console
curl -sLS https://get.k3sup.dev | sh
sudo install k3sup /usr/local/bin/
sudo cp k3sup-arm64 /usr/local/bin/k3sup
```

#### Install kubectl and dependences, start k3s master node
```console
sudo apt install -y apt-transport-https gnupg2 ca-certificates -y
	
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo deb https://apt.kubernetes.io/ kubernetes-xenial main | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null

sudo apt update && sudo apt install kubectl

k3sup install --ip 195.2.75.173 --user medved
```
