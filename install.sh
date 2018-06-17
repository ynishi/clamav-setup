#!/bin/sh
# debian 8.3 or later 

apt install -y clamav clamav-daemon
systemctl stop clamav-freshclam
freshclam
systemctl start clamav-freshclam

orig=$(pwd)
mkdir -p /tmp/clamav_test
cd /tmp/clamav_test
curl -OL 'http://www.eicar.org/download/eicar.com'
curl -OL 'http://www.eicar.org/download/eicar.com.txt'
curl -OL 'http://www.eicar.org/download/eicar_com.zip'
curl -OL 'http://www.eicar.org/download/eicarcom2.zip'
clamscan --infected --remove --recursive -v .
if [ $? -ne 0 ]; then
  cd $orig
  echo failed clamscan 
  exit 1
fi
cd $orig

systemctl enable clamav-daemon
systemctl start clamav-daemon
