#!/bin/sh

#creating firefox Memory Script in /opt directory

cat <<EOF | sudo tee -a /opt/firefoxMem.sh
ps aux  | awk ' BEGIN {print "RAM used(MB)\tMem(%)\tFirefox\n------------------------------------------------------------------"} \
/\/Downloads\/firefox/ {printf "%0.2f%s%0.1f%s\n", line6=\$6/1024, "\t\t",line4=\$4, "\t" \$11; sum+=line6;mem0+=line4;} \
END {printf "%s%0.2f%s%0.1f%s", "------------------------------------------------------------------\n"\
,sum, "\t\t", mem0,"\n------------------------------------------------------------------\n"}' >> /tmp/moz.txt

sed -i 's/\/home\/$USER\/Downloads\/firefox\///g' /tmp/moz.txt

cat /tmp/moz.txt
EOF

#Make script executable
sudo chmod +x /opt/firefoxMem.sh

#Creating Firefox Memory Service in /etc/systemd/system directory
cat <<EOF | sudo tee -a /etc/systemd/system/firefoxMem.service
[Unit]
Description=Generate report showing firefox app aggregate memory usage
After=network.target

[Service]
ExecStart=/bin/bash /opt/firefoxMem.sh

[Install]
WantedBy=multi-user.target
EOF

#Creating Firefox Memory Timer in /etc/systemd/system directory
cat <<EOF | sudo tee -a /etc/systemd/system/firefoxMem.timer
[Unit]
Description=Timer to run firefoxMem.service
After=network.target

[Timer]
Unit=firefoxMem.service
OnBootSec=10min


[Install]
WantedBy=multi-user.target
EOF

echo -e "SETUP\v SUCCESSFULLY\v COMPLETED!!"

sudo systemctl daemon-reload
sudo systemctl enable firefoxMem.timer && sudo systemctl start firefoxMem.timer
sudo systemctl daemon-reload
systemctl list-timers

# journalctl -f -u firefoxMem.timer

echo -e "SETUP\v SUCCESSFULLY\v COMPLETED!!"
