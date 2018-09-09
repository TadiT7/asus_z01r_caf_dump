#!/system/bin/sh

#Author:Toby_Du@asus.com 
#	cobb_tu@asus.com
#   alex1_wang@asus.com
ATD_Interface_VERSION="V1.0.15"

VERSION="V0.1"
#	1. first version
#	2. ATD Interface VERSION: V1.0.15

#For case ZE550KL
PROJECT="ZC552KL"
#EMMC 
#ln -sf /system/bin/emmc_fw		  /data/data/emmc_fw 
#ln -sf /system/bin/emmc_size		  /data/data/emmc_size 
#ln -sf /system/bin/emmc_status		  /data/data/emmc_status 

#SD card
#ln -sf /system/bin/sd_status              /data/data/sd_status 

#Charger IC status
#ln -sf /system/bin/chargerIC_status       /data/data/chargerIC_status

#Battery
ln -sf /system/bin/battery_status         /data/data/battery_status
#ln -sf /system/bin/CHG_TYPE_now           /data/data/CHG_TYPE_now

#Touch
#touch IC status
ln -sf /vendor/bin/touch_status           /data/data/touch_status
#touch function
ln -sf /vendor/bin/touch_function         /data/data/touch_function
#touch selftest
ln -sf /vendor/bin/TPselftest         	  /data/data/TPselftest

#GaugeIC
#ln -sf /system/bin/GaugeIC                /data/data/gaugeIC_status

#LaserFocus_Status
ln -sf /system/bin/LaserFocus_Status       /data/data/LaserFocus_Status 

#<asus_wx20160410>+>>
rm /data/data/gsensor_status
ln -sf /vendor/bin/gsensor_status         /data/data/gsensor_status
rm /data/data/gyroscope_status
ln -sf /vendor/bin/gyroscope_status       /data/data/gyroscope_status
rm /data/data/ecompass_status
ln -sf /vendor/bin/ecompass_status        /data/data/ecompass_status
rm /data/data/lightsensor_status
ln -sf /vendor/bin/lightsensor_status     /data/data/lightsensor_status
rm /data/data/proximity_status
ln -sf /vendor/bin/proximity_status       /data/data/proximity_status
rm /data/data/hallsensor_status
ln -sf /vendor/bin/hall_sensor            /data/data/hallsensor_status
rm /data/data/SAR_sensor_status
ln -sf /vendor/bin/SAR_sensor_status            /data/data/SAR_sensor_status
#<asus_wx20160410>+<<


#TP_ID && TP_FW
#cat /sys/bus/i2c/drivers/Ft5x46/4-0038/touch_status | grep "Firmware version is" | busybox cut -b 21- > /data/data/TP_FW
#cat /sys/bus/i2c/drivers/Ft5x46/4-0038/touch_status | grep "Glass vendor is" | busybox cut -b 18- > /data/data/TP_ID

#audio status
ln -sf /vendor/bin/audio_codec_status   /data/data/audio_codec_status
ln -sf /vendor/bin/headset_status       /data/data/headset_status
