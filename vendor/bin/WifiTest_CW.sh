#!/system/bin/sh

iwpriv wlan0 ena_chain 2
if [ $? = "0" ];then
	echo "[WifiTest_CW] iwpriv wlan0 ena_chain 2 pass" > /dev/kmsg
else
	echo "FAIL"
	exit 0;
fi

case $1 in
    38 | 46 | 54 | 62 | 102 | 110 | 118 | 126 | 134 | 142 | 151 | 159)
        echo "[WifiTest_CW] iwpriv wlan0 set_cb 1" > /dev/kmsg
        iwpriv wlan0 set_cb 1
        ;;
    42 | 58 | 106 | 122 | 138 | 155)
        echo "[WifiTest_CW] iwpriv wlan0 set_cb 8" > /dev/kmsg
        iwpriv wlan0 set_cb 8
        ;;
    *)
        echo "[WifiTest_CW] iwpriv wlan0 set_cb 0" > /dev/kmsg
        iwpriv wlan0 set_cb 0
        ;;
esac

iwpriv wlan0 set_channel $1
if [ $? = "0" ];then
	echo "[WifiTest_CW] iwpriv wlan0 set_channel pass" > /dev/kmsg
else
	echo "FAIL"
	exit 0;
fi

iwpriv wlan0 tx_cw_rf_gen $3
if [ $? = "0" ];then
	echo "PASS"
	exit 1
else
	echo "FAIL"
	exit 0
fi

