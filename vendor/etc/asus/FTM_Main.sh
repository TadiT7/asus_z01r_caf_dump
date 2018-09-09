#!/vendor/bin/sh
#Author: alex1_wang@asus.com
#data:2016/03/02

ATD_Interface_VERSION="V1.0.15"
VERSION="V1.1"

# factory right
chmod 777 /vendor/factory
chmod 777 /data/data

# Enter/Leave Airplane Mode
chmod 777 /vendor/bin/SCurrentTest
ln -sf /vendor/bin/SCurrentTest                             /data/data/SCurrentTest

#Phone Info
mkdir /vendor/factory/PhoneInfodisk
ln -sf /vendor/bin/PhoneInfoTest                            /data/data/PhoneInfoTest

#touch 
chmod 777 /sys/class/input/input10/touch_function
ln -sf /vendor/bin/TP_Vender                                /data/data/TP_Vender
ln -sf /vendor/bin/touch_function                           /data/data/touch_function
ln -sf /vendor/bin/touch_status                             /data/data/touch_status
ln -sf /vendor/bin/TPselftest                               /data/data/Tpselftest
#Capsensor
ln -sf /vendor/bin/cap_status                               /data/data/CapSensor_BMMI_selftest
ln -sf /vendor/bin/Capselftest                              /data/data/CapSensor_selftest

#Key Test
chmod 777 /sys/module/qpnp_power_on/parameters/pwrkey_mode
ln -sf /vendor/bin/Keypad_Test                              /data/data/Keypad_Test
ln -sf /vendor/bin/Keypad_Test_Mode                         /data/data/Keypad_Test_Mode

#Vibrator
chmod 777 /sys/class/timed_output/vibrator/enable
chmod 777 /sys/class/timed_output/vibrator/vmax
chmod 777 /sys/class/leds/vibrator/activate
chmod 777 /sys/class/leds/vibrator/duration
chmod 777 /sys/class/leds/vibrator/vmax_mv
ln -sf /vendor/bin/VibratorTest                            /data/data/VibratorTest
ln -sf /vendor/bin/resperiod                               /data/data/resperiod
ln -sf /vendor/bin/GetVibrator_volt                        /data/data/GetVibrator_volt
ln -sf /vendor/bin/SetVibrator_volt                        /data/data/SetVibrator_volt

#FingerPrint
ln -sf /vendor/bin/fingerprint_status                      /data/data/fingerprint_status
ln -sf /vendor/bin/FingerPrintTest                         /data/data/FingerPrintTest
ln -sf /vendor/bin/SOTER                                   /data/data/SOTER
ln -sf /vendor/bin/IFAA                                   /data/data/IFAA

#virtual key led
ln -sf /vendor/bin/VKLedTest                               /data/data/VKLedTest

#Battery
ln -sf /vendor/bin/battery_status                          /data/data/battery_status
ln -sf /vendor/bin/battery_current_now                     /data/data/battery_current_now
ln -sf /vendor/bin/BatteryVoltage                          /data/data/BatteryVoltage
ln -sf /vendor/bin/BatteryCapacity                         /data/data/BatteryCapacity
ln -sf /vendor/bin/BatteryCurrent                          /data/data/BatteryCurrent
ln -sf /vendor/bin/read_battery_id_status                  /data/data/read_battery_id_status
ln -sf /vendor/bin/GaugeIC                                 /data/data/gaugeIC_status
ln -sf /vendor/bin/CheckPTCtool                            /data/data/CheckPTCtool
ln -sf /proc/driver/vbat_avg_2                             /data/data/CheckPTCtool_FCC1_VBAT
ln -sf /proc/driver/vbat_avg_1                             /data/data/CheckPTCtool_FCC2_VBAT

#charger limite
chmod 777 /proc/driver/charging_limit
chmod 777 /proc/driver/charger_limit_enable
chmod 777 /proc/driver/batt_charge_enable
ln -sf /proc/driver/charger_limit_enable                       /data/data/charger_limit_enable
ln -sf /vendor/bin/charger_limit                               /data/data/charger_limit
echo 1 > /data/data/charger_limit_enable
ln -sf /vendor/bin/EnableCharging                          /data/data/EnableCharging
ln -sf /vendor/bin/DisableCharging                         /data/data/DisableCharging
ln -sf /vendor/bin/Charger_NTC_Value                       /data/data/Charger_NTC_Value
ln -sf /vendor/bin/USB_WaterProof                          /data/data/USB_WaterProof
ln -sf /vendor/bin/CHG_TYPE_now                            /data/data/CHG_TYPE_now
ln -sf /vendor/bin/Adapter_ADC                             /data/data/Adapter_ADC
ln -sf /vendor/bin/chargerIC_status                        /data/data/chargerIC_status

#eMMC or UFS or sdcard
#/vendor/bin/eMMC.sh
ln -sf /vendor/bin/UFS_Size                           /data/data/emmc_size
ln -sf /vendor/bin/sd_status                           /data/data/sd_status
ln -sf /vendor/bin/UFS_fw                           /data/data/emmc_fw

#devices component status
/vendor/bin/devices_status.sh

#LED
ln -sf /vendor/bin/LedTest                                /data/data/LedTest

#PCBID
/vendor/bin/pcbid
ln -sf /vendor/bin/pcbid_status                           /data/data/pcbid_status
ln -sf /vendor/bin/pcbid_status_str                    /data/data/pcbid_status_str
ln -sf /vendor/bin/project_id                             /data/data/project_id
ln -sf /vendor/bin/hw_id                                  /data/data/hw_id
#ln -sf /vendor/bin/RF_SKU                                 /data/data/RF_SKU
ln -sf /vendor/bin/RF_SKU                                 /data/data/SkuInfo

#Wifi Test
ln -sf /vendor/bin/WifiTestClient                         /data/data/WifiTest

#USB
ln -sf /vendor/bin/USB_Thermal_Alert                       /data/data/USB_Thermal_Alert
ln -sf /vendor/bin/BatteryTemperature                      /data/data/BatteryTemperature
ln -sf /vendor/bin/USB_ConnectorTest                      /data/data/USB_ConnectorTest
ln -sf /vendor/bin/TypeC_Side_Detect                      /data/data/TypeC_Side_Detect

#WiFiMaxPower Test
ln -sf /vendor/bin/WiFiMaxPower                        /data/data/WiFiMaxPower

#FM
ln -sf /vendor/bin/fmtest                                 /data/data/fmtest

#GPS Test
ln -sf /vendor/bin/GpsTest                                /data/data/GpsTest


#BSP Sensor 

rm /data/data/GsensorCalibration
ln -sf /vendor/bin/GsensorCalibration /data/data/GsensorCalibration
rm /data/data/DUTSideUpDetect
ln -sf /vendor/bin/DUTSideUpDetect /data/data/DUTSideUpDetect
rm /data/data/EcompassTest
ln -sf /vendor/bin/ecompass_selftest /data/data/EcompassTest

rm /data/data/sensors_getdata
ln -sf /vendor/bin/sensors_getdata /data/data/sensors_getdata

rm /data/data/GsensorZaxisTest
ln -sf /vendor/bin/GsensorZaxisTest  /data/data/GsensorZaxisTest
projectid=`cat /proc/apid`
case $projectid in
*)
   #cm36656 
   rm /data/data/proximity_calibration_data
   ln -sf /vendor/bin/proximity_calibration_data             /data/data/proximity_calibration_data
   rm /data/data/proximity_calibration_start
   ln -sf /vendor/bin/proximity_calibration_start            /data/data/proximity_calibration_start
   rm /data/data/proximity_get_proxm
   ln -sf /vendor/bin/proximity_get_proxm                        /data/data/proximity_get_proxm
   rm /data/data/proximity_selection
   ln -sf /vendor/bin/proximity_selection                        /data/data/proximity_selection
   rm /data/data/proximity_spec
   ln -sf /vendor/etc/proximity_spec                        /data/data/proximity_spec
   rm /data/data/frgbsensor_calibration_start
   ln -sf /vendor/bin/frgbsensor_calibration_start                 /data/data/frgbsensor_calibration_start
   rm /data/data/frgbsensor_calibration_data
   ln -sf /vendor/bin/frgbsensor_calibration_data                  /data/data/frgbsensor_calibration_data
   rm /data/data/frgbsensor_get_raw
   ln -sf /vendor/bin/frgbsensor_get_raw                 /data/data/frgbsensor_get_raw
   rm /data/data/lightsensor_calibration_start
   ln -sf /vendor/bin/lightsensor_calibration_start          /data/data/lightsensor_calibration_start
   rm /data/data/lightsensor_selection
   ln -sf /vendor/bin/lightsensor_selection                  /data/data/lightsensor_selection
   rm /data/data/lightsensor_calibration_data
   ln -sf /vendor/bin/lightsensor_calibration_data           /data/data/lightsensor_calibration_data
   rm /data/data/lightsensor_get_adc
   ln -sf /vendor/bin/lightsensor_get_adc                        /data/data/lightsensor_get_adc
   rm /data/data/FrontRGB_status
   ln -sf /vendor/bin/FrontRGB_status                        /data/data/FrontRGB_status
   rm /data/data/frgbsensor_get_fcct
   ln -sf /vendor/bin/frgbsensor_get_fcct                /data/data/frgbsensor_get_fcct
   rm /data/data/frgbsensor_get_div
   ln -sf /vendor/bin/frgbsensor_get_div                /data/data/frgbsensor_get_div
   rm /data/data/RGBSensor_value
   ln -sf /vendor/bin/RGBSensor_value                       /data/data/RGBSensor_value
   rm /data/data/RGBSensor_cal
   ln -sf /vendor/bin/RGBSensor_cal                         /data/data/RGBSensor_cal
   rm /data/data/RGBSensor_get_golden
   ln -sf /vendor/bin/RGBSensor_get_golden                  /data/data/RGBSensor_get_golden
   rm /data/data/RGB_status
   ln -sf /vendor/bin/RGBsensor_status                      /data/data/RGB_status
   rm /data/data/CSTest
   ln -sf /vendor/bin/CSTest                      /data/data/CSTest
;;
esac
#BSP Sensor 





#default enable 2G/3G/LTE
/vendor/bin/svc data enable

#BT Test
ln -sf /system/bin/btrftest                               /data/data/BtTest

#Telephony/Modem Test
ln -sf /vendor/bin/SIMTest                                /data/data/SIMTest
ln -sf /vendor/bin/RFTest                                 /data/data/RFTest
ln -sf /vendor/bin/MdmFW                                  /data/data/MdmFW
ln -sf /vendor/bin/RFSupportTech                          /data/data/RFSupportTech
#ln -sf /vendor/bin/RFMaxPower                             /data/data/RFMaxPower
ln -sf /vendor/bin/ReadICCID                              /data/data/ReadICCID
chmod 777 /dev/smd7

#camera
ln -sf /vendor/bin/CameraResolution                       /data/data/CameraResolution
ln -sf /vendor/bin/camera_status                          /data/data/camera_status
ln -sf /vendor/bin/vga_status                             /data/data/vga_status
ln -sf /vendor/bin/dit_af_cali                            /data/data/dit_af_cali
ln -sf /vendor/bin/dit_cali                               /data/data/dit_cali
ln -sf /vendor/bin/BackupCalibrationData                  /data/data/BackupCalibrationData
ln -sf /vendor/bin/CameraModule                           /data/data/CameraModule
ln -sf /vendor/bin/CameraOTP                              /data/data/CameraOTP
ln -sf /vendor/bin/CameraTest                             /data/data/CameraTest
ln -sf /vendor/bin/DualCamera                             /data/data/DualCamera
ln -sf /vendor/bin/CameraQcom                             /data/data/CameraQcom
ln -sf /vendor/bin/DualQcom                               /data/data/DualQcom
ln -sf /vendor/bin/Camera_Unique_ID                       /data/data/Camera_Unique_ID
ln -sf /vendor/bin/RestoreCalibrationData                 /data/data/RestoreCalibrationData
ln -sf /vendor/bin/KillMediaserver                        /data/data/KillMediaserver
ln -sf /vendor/bin/CameraEEPROM                           /data/data/CameraEEPROM
ln -sf /vendor/bin/camera_flash                           /data/data/camera_flash
ln -sf /vendor/bin/Camera_OIS_Power                       /data/data/Camera_OIS_Power
ln -sf /vendor/bin/Camera_OIS	                          /data/data/Camera_OIS
ln -sf /vendor/bin/Camera_OIS_GyroCal                     /data/data/Camera_OIS_GyroCal
ln -sf /vendor/bin/Camera_OIS_Write	                  /data/data/Camera_OIS_Write
ln -sf /vendor/bin/Camera_OIS_Read	                  /data/data/Camera_OIS_Read
ln -sf /vendor/bin/Camera_OIS_Rdata	                  /data/data/Camera_OIS_Rdata
ln -sf /vendor/bin/Camera_OIS_Write_DAC	              /data/data/Camera_OIS_Write_DAC
ln -sf /vendor/bin/ditbsp	                          /data/data/ditbsp
ln -sf /vendor/bin/dit_cali_golden	                  /data/data/dit_cali_golden
ln -sf /vendor/bin/test_afCaliDB	                  /data/data/test_afCaliDB
ln -sf /vendor/bin/q_af_cali                            /data/data/q_af_cali
ln -sf /vendor/bin/q_ae_cali                            /data/data/q_ae_cali
ln -sf /vendor/bin/q_cali                               /data/data/q_cali
ln -sf /vendor/bin/q_cali_golden                        /data/data/q_cali_golden
ln -sf /vendor/bin/test_qafCali                         /data/data/test_qafCali
ln -sf /vendor/bin/test_BinMerge                        /data/data/test_BinMerge
ln -sf /vendor/bin/test_DualCamQcomAECali               /data/data/test_DualCamQcomAECali
ln -sf /vendor/bin/test_ShadingCaliForQcom              /data/data/test_ShadingCaliForQcom
CameraWriteCalikeys

#Thermal
ln -sf /vendor/bin/Thermal                                /data/data/Thermal

#brightnesss
chmod 777 /sys/class/backlight/panel0-backlight/brightness
ln -sf /sys/class/backlight/panel0-backlight/brightness                    /data/data/BLTest

#Audio
touch /data/local/tmp/tfa98xx-sysfs.lck
chmod 0666 /data/local/tmp/tfa98xx-sysfs.lck
chown root root /data/local/tmp/tfa98xx-sysfs.lck
chmod 777 /vendor/bin/AudioRoutingTest
ln -sf /vendor/bin/AudioRoutingTest                   /data/data/AudioRoutingTest
ln -sf /vendor/bin/AudioRoutingTest                   /data/data/select_mic
ln -sf /vendor/bin/AudioRoutingTest                   /data/data/select_output
chmod 777 /vendor/bin/ReadReceiverCalibrationValue
ln -sf /vendor/bin/ReadReceiverCalibrationValue                   /data/data/ReadReceiverCalibrationValue
chmod 777 /vendor/bin/ReadSpeakerCalibrationValue
ln -sf /vendor/bin/ReadSpeakerCalibrationValue                   /data/data/ReadSpeakerCalibrationValue
chmod 0777 /sys/bus/i2c/devices/i2c-2/2-0034/reg
chmod 0777 /sys/bus/i2c/devices/i2c-2/2-0034/rw
chmod 0777 /sys/bus/i2c/devices/i2c-2/2-0035/reg
chmod 0777 /sys/bus/i2c/devices/i2c-2/2-0035/rw
chown system shell /dev/i2c-2
chmod 0777 /dev/i2c-2
chmod 777 /vendor/bin/AMPcalibration
ln -sf /vendor/bin/AMPcalibration                   /data/data/SpeakerCalibrationTest
chmod 777 /proc/driver/audio_debug
chmod 777 /proc/driver/headset_status
chmod 777 /vendor/bin/audio_codec_status
ln -sf /vendor/bin/audio_codec_status                /data/data/audio_codec_status
chmod 777 /proc/driver/audio_codec
chmod 777 /vendor/bin/headset_status
ln -sf /vendor/bin/headset_status                    /data/data/headset_status
chmod 777 /vendor/bin/audio_amplifier_status
ln -sf /vendor/bin/audio_amplifier_status            /data/data/audio_amplifier_status

echo "linkerror" > /data/data/linkerror

