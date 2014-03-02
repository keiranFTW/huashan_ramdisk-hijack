#!/bin/bash

cd ramdisk-hijack
adb push charger /data/local/tmp/
adb push chargemon /data/local/tmp/
adb push ric /data/local/tmp/
adb push hijack.tar /data/local/tmp/
adb push filestocopy.sh /data/local/tmp/
# for recovery only
adb push hijack/busybox /data/local/tmp/
# install files on phone
adb shell chmod 755 /data/local/tmp/filestocopy.sh
adb shell su -c /data/local/tmp/filestocopy.sh
