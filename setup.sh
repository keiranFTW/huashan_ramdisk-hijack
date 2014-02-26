#!/bin/bash

cd ramdisk-hijack/hijack
if [ -e jelly.tar ]; then
    rm jelly.tar
fi
cd ramdisk
tar -cvzf ../jelly.tar *
cd ../..
if [ -e hijack.tar ]; then
    rm hijack.tar
fi
cd hijack
tar -cvzf ../hijack.tar $(ls | grep -v "ramdisk")
cd ../..
echo "Done."
read

