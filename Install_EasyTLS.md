# Install EasyTLS

Find out actual [release](https://github.com/TinCanTech/easy-tls/releases) of easytls and change $tlslink 
```sh
export tlslink=https://github.com/TinCanTech/easy-tls/files/7873797/easytls-2.7.0.tar.gz
export tlstgz=$(echo $tlslink | rev | cut -f1 -d"/" | rev)

cd ~/easyrsa

wget $tlslink
tar zxvf $tlstgz
rm $tlstgz

### cd ~/scripts
### sudo chmod +x easytls.sh
### ./easytls.sh
```
## Generating tls certs
```sh
cd ~/easyrsa
sudo ./easytls init-tls
#Your newly created TLS dir is: ./pki/easytls

sudo ./easytls build-tls-auth
#TLS auth key created: ./pki/easytls/tls-auth.key

sudo ./easytls build-tls-crypt
#TLS crypt v1 key created: ./pki/easytls/tls-crypt.key

sudo ./easytls build-tls-crypt-v2-server VDSina
#TLS crypt v2 server key created: ./pki/easytls/VDSina-tls-crypt-v2.key

-----
sudo ./easytls build-tls-crypt-v2-client VDSina Pi4B
#TLS crypt v2 client key created: ./pki/easytls/Pi4B-tls-crypt-v2.key

#./easytls build-tls-crypt-v2-client VDSina X3Pro
#./easytls build-tls-crypt-v2-client VDSina 2Pro360
#./easytls build-tls-crypt-v2-client VDSina T440
#./easytls build-tls-crypt-v2-client VDSina Olly
```
