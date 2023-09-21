## Install easyrsa

Find out [actual release](https://github.com/OpenVPN/easy-rsa/releases) of easyrsa and change $rsalink 

`rev` - revert string $rsalink

`cut -f1 -d"/"` - cut all characters after symbol "/"

`sed 's/....$//'` - delete 5 symbols from the end of $rsalink

```sh
export rsalink=https://github.com/OpenVPN/easy-rsa/releases/download/v3.1.6/EasyRSA-3.1.6.tgz
export rsatgz=$(echo $rsalink | rev | cut -f1 -d"/" | rev)
export rsadir=$(echo $rsalink | rev | cut -f1 -d"/" | rev | sed 's/....$//')
```
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
### ./easyrsa.sh
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
## Creating a server certificate, key, and encryption files
```sh
./easyrsa build-ca nopass
#CA creation complete. Your new CA certificate is at: /home/medved/easyrsa/pki/ca.crt

./easyrsa gen-dh nopass
#DH parameters of size 2048 created at: /home/medved/easyrsa/pki/dh.pem

./easyrsa build-server-full VDSina nopass
#Certificate created at: /home/medved/easyrsa/pki/issued/VDSina.crt
#Inline file created: /home/medved/easyrsa/pki/inline/VDSina.inline

sudo openvpn --genkey --secret pki/ta.key
#/home/medved/easyrsa/pki/ta.key
-----
./easyrsa build-client-full Pi4B nopass
#Certificate created at: /home/medved/easyrsa/pki/issued/Pi4B.crt
#Inline file created: /home/medved/easyrsa/pki/inline/Pi4B.inline

#./easyrsa build-client-full X3Pro nopass
#./easyrsa build-client-full 2Pro360 nopass
#./easyrsa build-client-full T440 nopass
#./easyrsa build-client-full Olly nopass
```
./easyrsa --san=DNS:Pi4B,DNS:medvedcloud,DNS:medvedcloud.local,DNS:medvedcloud.lan,DNS:medvedcloud.duckdns.org build-server-full Pi4B-k8s nopass
#Certificate created at: /home/medved/easyrsa/pki/issued/Pi4B-k8s.crt
#Inline file created: /home/medved/easyrsa/pki/inline/Pi4B-k8s.inline
