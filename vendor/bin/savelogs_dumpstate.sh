#!/vendor/bin/sh
GENERAL_LOG=/data/media/0/ASUS/LogUploader/general/sdcard
BUGREPORT_PATH=/data/user_de/0/com.android.shell/files/bugreports
#mkdir -p $GENERAL_LOG
#dumpstate -q > $GENERAL_LOG/dumpstate.txt
#dumpstate -q -d -z -o $BUGREPORT_PATH/bugreport
for filename in $BUGREPORT_PATH/*; do
    name=${filename##*/}
    cp  $filename $GENERAL_LOG
    rm $filename
done

chmod -R 777 $GENERAL_LOG/
setprop persist.asus.savelogs.complete 1
setprop persist.asus.savelogs.complete 0
