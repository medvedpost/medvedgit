# Install easyrsa easytls openvpn 
## Install easyrsa

Find out actual [release](https://github.com/OpenVPN/easy-rsa/releases) of easyrsa and change $rsalink 

```sh
export rsalink=https://github.com/OpenVPN/easy-rsa/releases/download/v3.1.6/EasyRSA-3.1.6.tgz
export rsatgz=$(echo $rsalink | rev | cut -f1 -d"/" | rev)
export rsadir=$(echo $rsalink | rev | cut -f1 -d"/" | rev | sed 's/....$//')

mkdir easyrsa
cd easyrsa

wget $rsalink
tar zxvf $rsatgz
mv ./$rsadir/* ./
rm $rsatgz
rm-rf $rsadir
