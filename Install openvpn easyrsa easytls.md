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
### cd ~/scripts
### sudo chmod +x easyrsa.sh
### sudo ./easyrsa.sh
```
## Generate [rsa certs](https://community.openvpn.net/openvpn/wiki/EasyRSA3-OpenVPN-Howto)

```sh
cd ~/easyrsa
./easyrsa init-pki
# Your newly created PKI dir is: /home/medved/easyrsa/pki
# Using Easy-RSA configuration: /home/medved/easyrsa/pki/vars
```
```sh
tee -a <<EOF > /home/medved/easyrsa/pki/vars
set_var EASYRSA_DN              "org"

set_var EASYRSA_REQ_COUNTRY     "VN"
set_var EASYRSA_REQ_PROVINCE    "Danang"
set_var EASYRSA_REQ_CITY        "Danang City"
set_var EASYRSA_REQ_ORG         "Starfish Alley"
set_var EASYRSA_REQ_EMAIL       "medvedcloud.duckdns.org"
set_var EASYRSA_REQ_OU          "Medved Cloud"

set_var EASYRSA_NO_PASS         "1"
set_var EASYRSA_KEY_SIZE        "2048"
set_var EASYRSA_ALGO            "rsa"
set_var EASYRSA_CA_EXPIRE       "3650"
set_var EASYRSA_CERT_EXPIRE     "3650"
set_var EASYRSA_RAND_SN         "yes"
EOF
```
```sh
./easyrsa build-ca nopass
#CA creation complete. Your new CA certificate is at: /home/medved/easyrsa/pki/ca.crt

./easyrsa gen-dh nopass
#DH parameters of size 2048 created at: /home/medved/easyrsa/pki/dh.pem

./easyrsa build-server-full VDSina nopass
#Certificate created at: /home/medved/easyrsa/pki/issued/VDSina.crt
#Inline file created: /home/medved/easyrsa/pki/inline/VDSina.inline
-----
./easyrsa build-client-full Pi4B nopass
#Certificate created at: /home/medved/easyrsa/pki/issued/Pi4B.crt
#Inline file created: /home/medved/easyrsa/pki/inline/Pi4B.inline

#./easyrsa build-client-full X3Pro nopass
#./easyrsa build-client-full 2Pro360 nopass
#./easyrsa build-client-full T440 nopass
#./easyrsa build-client-full Olly nopass
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
cd ~/easyrsa
./easytls init-tls
#Your newly created TLS dir is: ./pki/easytls

./easytls build-tls-auth
#TLS auth key created: ./pki/easytls/tls-auth.key

./easytls build-tls-crypt
#TLS crypt v1 key created: ./pki/easytls/tls-crypt.key

./easytls build-tls-crypt-v2-server VDSina
#TLS crypt v2 server key created: ./pki/easytls/VDSina-tls-crypt-v2.key

-----
./easytls build-tls-crypt-v2-client VDSina Pi4B
#TLS crypt v2 client key created: ./pki/easytls/Pi4B-tls-crypt-v2.key

./easytls build-tls-crypt-v2-client VDSina X3Pro
./easytls build-tls-crypt-v2-client VDSina 2Pro360
./easytls build-tls-crypt-v2-client VDSina T440
./easytls build-tls-crypt-v2-client VDSina Olly
```
## Install openvpn
```sh
apt install openvpn -y
```
```sh
sudo chmod 777 /etc/openvpn/

tee -a <<EOF > /etc/openvpn/server.conf
port 1194
proto udp
dev tun
ca ca.crt
cert VDSina.crt
key VDSina.key  # This file should be kept secret
dh dh.pem
server 10.3.3.0 255.255.255.0
ifconfig-pool-persist /var/log/openvpn/ipp.txt
client-to-client
keepalive 10 120
cipher AES-256-GCM
auth SHA256
user nobody
group nogroup
persist-key
persist-tun
status /var/log/openvpn/openvpn-status.log
verb 3
explicit-exit-notify 1
EOF
```
```sh
cp ~/easyrsa/pki/{ca.crt,dh.pem} /etc/openvpn
cp ~/easyrsa/pki/easytls/tls-auth.key /etc/openvpn
cp ~/easyrsa/pki/issued/VDSina.crt /etc/openvpn
cp ~/easyrsa//pki/private/VDSina.key /etc/openvpn
```
```sh
sudo chmod 777 /etc/sysctl.conf

tee -a <<EOF >> /etc/sysctl.conf
net.ipv4.ip_forward=1
EOF

sudo sysctl -p
```
```sh
sudo systemctl start openvpn@server 
sudo systemctl enable openvpn@server
```
