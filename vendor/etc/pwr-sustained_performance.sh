#!/system/bin/sh
#This is sustained performance mode, set cpu to performance mode.

# configure governor settings for little cluster
echo "performance" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

# configure governor settings for big cluster
echo "performance" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
