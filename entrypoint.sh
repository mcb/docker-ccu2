#!/bin/sh
echo "Configuring GPIO"
if [ ! -d /sys/class/gpio/gpio18 ] ; then
  echo 18 > /sys/class/gpio/export
fi
echo out > /sys/class/gpio/gpio18/direction

echo
echo "Check if /etc/config/keys exits"
if [ ! -f /etc/config/keys ] ; then
cat <<EOF > /etc/config/keys
current Index = 1
Key 0 =
Key 1 = $(cat /dev/urandom|tr -dc A-F0-9 | head -c32)
Last Index = 0
EOF
echo "Created /etc/config/keys with urandom"
cat /etc/config/keys
fi

echo
echo "Check if /etc/config/ids exits"
if [ ! -f /etc/config/ids ] ; then
cat <<EOF > /etc/config/ids
BidCoS-Address=0x12EC17
SerialNumber=GEQ0174613
EOF
echo "Created /etc/config/ids with hard-coded serial numbers"
cat /etc/config/ids
fi

echo
echo "Starting CCU2 init scripts"
for i in /etc/init.d/S*; do echo; echo "Starting $i"; $i start; done
killall hss_led #Because it is very verbose when it cannot find the CCU2 leds
echo "Done starting CCU2 init scripts"
/bin/sh




#OLD: before we used to start selected services only
#/etc/init.d/S50lighttpd start
#/bin/eq3configcmd update-coprocessor -lgw -u -rfdconf /etc/config/rfd.conf -l 1
#/bin/eq3configcmd update-lgw-firmware -m /firmware/fwmap -c /etc/config/rfd.conf -l 1
##/bin/eq3configcmd update-lgw-firmware -m /firmware/fwmap -c /etc/config/hs485d.conf -l 1
#/bin/rfd -f /etc/config/rfd.conf -l 1 &
#/etc/init.d/S62HMServer start
#/etc/init.d/S70ReGaHss start
#/bin/sh