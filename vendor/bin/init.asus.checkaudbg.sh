#!/system/bin/sh
audbg_mode=`getprop persist.asus.audbg`
is_factory_build=`getprop ro.asus.factory`
echo "check audio debug mode $audbg_mode" > /proc/driver/audio_debug
case "$audbg_mode" in
  "0")
    setprop persist.asus.audbg 0
    ;;
  "1")
    setprop persist.asus.audbg 1
    ;;
  "")
    if [ "$is_factory_build" == "1" ]; then
        setprop persist.asus.audbg 1
    else
        setprop persist.asus.audbg 0
    fi
    ;;
esac
