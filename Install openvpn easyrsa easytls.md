# Install easyrsa easytls openvpn 
## Install easyrsa

Find out actual [release](https://github.com/OpenVPN/easy-rsa/releases) of easyrsa and change $rsalink 

```sh
export rsalink=https://github.com/OpenVPN/easy-rsa/releases/download/v3.1.6/EasyRSA-3.1.6.tgz
export rsatgz=$(echo $rsalink | rev | cut -f1 -d"/" | rev)
export rsadir=$(echo $rsalink | rev | cut -f1 -d"/" | rev | sed 's/....$//')
```
`rev` - revert string $rsalink

`cut -f1 -d"/"` - cut all characters after symbol "/"

`sed 's/....$//'` - delete 5 symbols from the end of $rsalink
```sh
mkdir ~/easyrsa 
cd ~/easyrsa

wget $rsalink 
tar zxvf $rsatgz 
mv ./$rsadir/* ./

rm $rsatgz
rm -rf $rsadir
```
## Generate rsa certs
```sh
cd ~/easyrsa
./easyrsa init-pki
./easyrsa build-ca
./easyrsa gen-dh
./easyrsa build-server-full VDSina
-----
./easyrsa build-client-full Pi4B
./easyrsa build-client-full X3Pro
./easyrsa build-client-full 2Pro360
./easyrsa build-client-full T440
./easyrsa build-client-full Olly
```
## Install easytls
Find out actual [release](https://github.com/TinCanTech/easy-tls/releases) of easytls and change $tlslink 
```sh
export tlslink=https://github.com/TinCanTech/easy-tls/files/7873797/easytls-2.7.0.tar.gz
export tlstgz=$(echo $tlslink | rev | cut -f1 -d"/" | rev)

cd ~/easyrsa

wget $tlslink
tar zxvf $tlstgz
rm $tlstgz
```

## Generating tls certs
```sh
./easytls init-tls
./easytls build-tls-auth
./easytls build-tls-crypt
./easytls build-tls-crypt-v2-server VDSina
-----
./easytls build-tls-crypt-v2-client VDSina Pi4B
./easytls build-tls-crypt-v2-client VDSina X3Pro
./easytls build-tls-crypt-v2-client VDSina 2Pro360
./easytls build-tls-crypt-v2-client VDSina T440
./easytls build-tls-crypt-v2-client VDSina Olly
```
