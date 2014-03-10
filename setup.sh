#!/bin/bash

cd ramdisk-hijack/hijack
if [ -e cm.tar ]; then
    rm cm.tar
fi
cd ramdisk
tar -cvzf ../cm.tar *
cd ../..
if [ -e hijack.tar ]; then
    rm hijack.tar
fi
cd hijack
tar -cvzf ../hijack.tar $(ls | grep -v "ramdisk")
cd ../..
echo "Done."

