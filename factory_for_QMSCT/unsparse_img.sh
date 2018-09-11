#!/bin/bash

# ======================= used in img release bag =====================================
mv ../firmware/* ../
rm -rf ../firmware
mv ../modem/* ../
rm -rf ../modem
cp ./* ../
cd ../
python checksparse.py -i rawprogram0.xml -o rawprogram_unsparse0.xml -s ./
python checksparse.py -i rawprogram4.xml -o rawprogram_unsparse4.xml -s ./
rm system.img
rm vendor.img
rm persist.img
rm userdata.img
rm update_image.bat
rm update_image.sh
