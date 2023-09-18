# Install OpenVPN
```sh
sudo apt update && sudo apt upgrade -y
```

## Install OpenVPN service
```sh
apt install openvpn -y
```
## Install easyrsa
[Install EasyRSA ang generate certs](!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!)

## Copy certs and keys to default OpenVPN folder
```sh
sudo chmod 777 /etc/openvpn/
#drwxr-xr-x  4 root root   4.0K Sep 14 17:41 openvpn

sudo cp ~/easyrsa/pki/{ca.crt,ta.key,dh.pem___} /etc/openvpn
sudo cp ~/easyrsa/pki/issued/VDSina.crt /etc/openvpn
sudo cp ~/easyrsa/pki/private/{ca.key,VDSina.key} /etc/openvpn
```
## Configure OpenVPN (SERVER side)
```sh
tee -a <<EOF > /etc/openvpn/server.conf
port 1194
proto udp
dev tun
ca ca.crt
cert VDSina.crt
key VDSina.key  # This file should be kept secret
dh dh.pem
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist /var/log/openvpn/ipp.txt
client-to-client
keepalive 10 120
tls-auth ta.key 0
key-direction 0
cipher AES-128-CBC
auth SHA256
user nobody
group nogroup
persist-key
persist-tun
status /var/log/openvpn/openvpn-status.log
log /var/log/openvpn/openvpn.log
verb 3
explicit-exit-notify 1
EOF
```

## Start OpenVPN service (SERVER side)
```sh
sudo systemctl start openvpn@server 
sudo systemctl enable openvpn@server
#sudo systemctl status openvpn@server
```

## Install and copy config to default OpenVPN folder (CLIENT side)
```sh
sudo apt install openvpn
#sudo openvpn --config Pi4B.conf
sudo cp Pi4B.conf /etc/openvpn/
```

## Start OpenVPN service (CLIENT side)
```sh
sudo systemctl enable openvpn@Pi4B
sudo systemctl daemon-reload
sudo systemctl start openvpn@Pi4b
#sudo systemctl status openvpn@Pi4b
```
