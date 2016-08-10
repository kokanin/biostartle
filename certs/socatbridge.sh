socat -v -x TCP4-LISTEN:1480 openssl-connect:192.168.116.139:1480,verify=0,cert=./bioadmin_client.crt,key=./bioadmin_client.key 
