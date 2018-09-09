#!/system/bin/sh

logi () {
#	echo "<5> WifiTest_Agent : $@" > /dev/kmsg
	log -p i -t WifiTest_Agent $@
}

loge () {
#	echo "<3> WifiTest_Agent : $@" > /dev/kmsg
	log -p e -t WifiTest_Agent $@
}

cmd=`getprop wlan.ftm.cmd`
logi "get command \"$cmd\""

if [ "$cmd" = "" ]; then
	loge "[ERR] command is null"
fi

for i in $cmd
do
	if [ "$i" = "WifiTest" ];then
#		logi "[INFO] WifiTest command recognized"
		break;
	elif [ "$i" = "WifiTest_CW.sh" ];then
#		logi "[INFO] WifiTest_CW.sh command recognized"
		break;
	else
		loge "[ERR] unknown command"
		setprop wlan.ftm.status "Not WifiTest Cmd"
		exit 0
	fi
	break
done

result=`$cmd`
status=$?
setprop wlan.ftm.data "$result"
logi "\"$cmd\" returns \"$result\""

if [ $status = "1" ];then
	loge "setprop wlan.ftm.status pass"
	setprop wlan.ftm.status "pass"
else
	loge "setprop wlan.ftm.status fail"
	setprop wlan.ftm.status "fail"
fi
