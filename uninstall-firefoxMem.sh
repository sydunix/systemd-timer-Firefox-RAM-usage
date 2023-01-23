#!/bin/sh
sudo systemctl stop firefoxMem.timer
sudo systemctl disable firefoxMem.timer
sudo systemctl daemon-reload
sudo systemctl status firefoxMem.timer
sudo rm /opt/firefoxMem.sh /etc/systemd/system/firefoxMem.service /etc/systemd/system/firefoxMem.timer
sudo systemctl status firefoxMem.timer

echo -e "UNINSTALL\v SUCCESSFULLY\v COMPLETED!!"
