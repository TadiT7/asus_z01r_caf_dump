#!/bin/bash

echo "Flash GPT 0"
sudo ./fastboot flash partition:0 gpt_both0.bin
if [ $? != 0 ]; then
    echo "Flash GPT 0 fail"
fi

echo "Flash GPT 4"
sudo ./fastboot flash partition:4 gpt_both4.bin
if [ $? != 0 ]; then
    echo "Flash GPT 0 fail"
fi

sudo ./fastboot reboot-bootloader
echo now run update_image.sh