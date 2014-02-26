#!/system/bin/sh
mount -o remount, rw /system

dd if=/data/local/tmp/charger of=/system/bin/charger
chown root.shell /system/bin/charger
chmod 755 /system/bin/charger

dd if=/data/local/tmp/chargemon of=/system/bin/chargemon
chown root.shell /system/bin/chargemon
chmod 755 /system/bin/chargemon

dd if=/data/local/tmp/ric of=/system/bin/ric
chown root.shell /system/bin/ric
chmod 755 /system/bin/ric

dd if=/data/local/tmp/hijack.tar of=/system/bin/hijack.tar
chown root.shell /system/bin/hijack.tar
chmod 644 /system/bin/hijack.tar

## for recovery only

if [ ! -d /system/btmgr ]; then
  mkdir /system/btmgr
fi

if [ ! -d /system/btmgr/bin ]; then
  mkdir /system/btmgr/bin
fi

dd if=/data/local/tmp/busybox of=/system/btmgr/bin/busybox
chown root.shell /system/btmgr/bin/busybox
chmod 755 /system/btmgr/bin/busybox

mount -o remount, ro /system
