IP=`ip address show dev eth0 | grep inet | head -n1 | cut -d ' ' -f 6 | cut -d '/' -f 1`
echo $IP
sed -i "s/0.0.0.0:21337/$IP:21337/" witnet.toml
