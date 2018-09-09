#!/system/bin/sh
SAVE_LOG_PATH=`getprop asus.savelogmtp.folder`
savelog_upload=`getprop asus.savelogmtp.forupload`
setprop asus.savelogmtp.testjojo start
setprop asus.savelogmtp.testa $SAVE_LOG_PATH
setprop asus.savelogmtp.testupload $savelog_upload
if [ ".$savelog_upload" == ".1" ]; then
	SAVE_LOG_PATH="/data/media/0/ASUS/LogUploader/general/sdcard"
	setprop asus.savelogmtp.testg setupload
	setprop asus.savelogmtp.forupload 0
elif [ ".$SAVE_LOG_PATH" == "." ]; then
	SAVE_LOG_PATH="/data/media/0/ASUS/LogUploader/general/sdcard"
	setprop asus.savelogmtp.testg nofolder
fi
setprop asus.savelogmtp.testb $SAVE_LOG_PATH
DUMP_LOG_PATH=$SAVE_LOG_PATH"/Dumpsys"
mkdir  /data/media/0/ASUS/LogUploader/general/sdcard/bugreport
mkdir  $DUMP_LOG_PATH

setprop asus.savelogmtp.testc $DUMP_LOG_PATH

setprop debug.asus.savelogmtp.dumpstate 1

for x in SurfaceFlinger window activity input_method alarm power battery batterystats audio cpuinfo meminfo power wifi diskstats; do
	dumpsys $x > $DUMP_LOG_PATH/$x.txt
	echo "dumpsys $x > $SAVE_LOG_PATH/$x.txt"
done

dumpsys window -a > $DUMP_LOG_PATH/window.txt
	# save debug report
dumpsys > $DUMP_LOG_PATH/dumpsys.txt
#dumpstate -q -d -z -o /data/media/0/ASUS/LogUploader/general/sdcard/bugreport
 BUGREPORT_PATH=/data/user_de/0/com.android.shell/files/bugreports
for filename in $BUGREPORT_PATH/*; do
    name=${filename##*/}
    cp  $filename $SAVE_LOG_PATH
    rm $filename
done

CHECK_DUMPSTATE_OK=`getprop init.svc.dumpstatesv`

setprop asus.savelogmtp.testwait 0
for i in $(seq 60); do		
	setprop asus.savelogmtp.testwait 1
	if [ ".$CHECK_DUMPSTATE_OK" == ".stopped" ]; then
		break
	elif [ ".$CHECK_DUMPSTATE_OK" == "." ]; then
		break
	else	
		sleep 2
	fi
done;
setprop debug.asus.savelogmtp.dumpstate 0
setprop asus.savelogmtp.testwait 2
cp -rf /data/media/0/ASUS/LogUploader/general/sdcard/bugreport $SAVE_LOG_PATH

chmod -R 777 $SAVE_LOG_PATH/
setprop persist.asus.savelogs.complete 1
setprop persist.asus.savelogs.complete 0
setprop debug.asus.savelogmtp.savedumpsyslogs 0
