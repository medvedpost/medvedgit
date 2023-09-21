```sh
sudo apt update && sudo apt upgrade && sudo apt autoremove
```

#### [Generating public/private rsa key pair](https://andreyex.ru/linux/kak-dobavit-otkrytyj-klyuch-ssh-na-server/)
```sh
mkdir /home/medved/.ssh/
sudo ssh-keygen -t rsa -f /home/medved/.ssh/id_rsa
cp ~/.ssh/id_rsa.pub  ~/.ssh/authorized_keys
```
```sh
ssh medved@Pi4B
sudo chmod 777 /home/medved/.ssh/id_rsa
sudo echo "HostbasedAuthentication yes" | sudo tee -a /etc/ssh/sshd_config
#sudo mkdir /root/.ssh
#cp -r /home/medved/.ssh/. /root/.ssh/
```
```sh
if [ -z "$(sudo grep 'medved ALL=(ALL:ALL) ALL' /etc/sudoers )" ]
  then echo "medved ALL=(ALL:ALL) ALL" | sudo EDITOR='tee -a' visudo;
fi;
#sudo visudo
```

#### [Install OS dependencies](https://github.com/philschatz/nextcloud-kubernetes-pi/blob/main/templates/install-os-deps.sh)
```sh
sudo apt install git pmount downtimed unattended-upgrades curl net-tools -y
```
#### [Install packages that reduce the churn on the SD card](https://github.com/philschatz/nextcloud-kubernetes-pi/blob/main/templates/install-disk-savers.sh)
Install zram-swap if it is not already running
```sh
systemctl -q is-active zram-swap || {
  [[ -d ./zram-swap ]] && rm -r ./zram-swap

  git clone https://github.com/foundObjects/zram-swap.git
  pushd ./zram-swap
  sudo ./install.sh
  popd
  rm -r ./zram-swap
};
```
```sh
systemctl status zram-swap
```
Install log2ram if it is not already running
```sh
systemctl -q is-active log2ram || {
  [[ -d ./log2ram-master ]] && rm -r ./log2ram-master 

  curl -Lo log2ram.tar.gz https://github.com/azlux/log2ram/archive/master.tar.gz
  tar xf log2ram.tar.gz
  pushd ./log2ram-master
  chmod +x install.sh && sudo ./install.sh
  popd
  rm -r ./log2ram-master
  rm ~/log2ram.tar.gz

  echo "SystemMaxUse=20M" | sudo tee -a /etc/systemd/journald.conf > /dev/null
};
```
```sh
sudo systemctl reboot
```
#### [Download and install local helpers (k3sup)](https://github.com/alexellis/k3sup)

```sh
curl -sLS https://get.k3sup.dev | sh
```

```sh
sudo cp k3sup /usr/local/bin/k3sup
sudo install k3sup /usr/local/bin/
sudo rm ~/k3sup
#sudo cp k3sup-arm64 /usr/local/bin/k3sup
#sudo install k3sup-arm64 /usr/local/bin/
#sudo rm ~/k3sup-arm64
```

#### Install kubectl and dependences, start k3s master node

```sh
sudo swapoff -a
sudo apt install -y apt-transport-https gnupg2 ca-certificates -y
	
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null

sudo apt update && sudo apt install kubectl

echo "cgroup_memory=1 cgroup_enable=memory" | sudo tee -a /boot/cmdline.txt
#console=serial0,115200 console=tty1 root=PARTUUID=39a0e3eb-02 rootfstype=ext4 fsck.repair=yes rootwait quiet splash plymouth.ignore-serial-consoles cgroup_memory=1 cgroup_enable=memory
```
```sh
sudo reboot
```
```sh
#k3sup install --local --user medved
#k3sup install --host Pi4B  --user medved
k3sup install --host Pi4B
export KUBECONFIG=/home/medved/kubeconfig
cp /home/medved/kubeconfig ~/.kube/config
kubectl config use-context default
kubectl get node -o wide
#/usr/local/bin/k3s-uninstall.sh
```
[REFERENCES](https://docs.k3s.io/installation/uninstall)
(https://github.com/alexellis/k3sup)
(https://github.com/philschatz/nextcloud-kubernetes-pi/tree/main)
