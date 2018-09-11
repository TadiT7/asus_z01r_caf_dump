#!/bin/bash

MARCO_PACKAGE_VARIANT_USERDEBUG="userdebug"
MARCO_PACKAGE_VARIANT_FACTORY="eng"
MARCO_PACKAGE_VARIANT_USER="user"
EVB_NAME="EVB"
SR_NAME="SR"
FB="./fastboot "

get_package_info()
{
	if [ -n "$1" ] ;then
		val=$(cat build_info | grep $1 | tr -d ' ' | cut -d'=' -f2)
		echo -n $val
	fi
}

get_project_name()
{
	pro_name=$(sudo $FB getvar product 2>&1 | grep product | awk '{print $2}')
	echo -n $pro_name
}

get_stage_id()
{
	stage_id=$(sudo $FB getvar stage-id 2>&1 | grep stage-id | awk '{print $2}')
	echo -n $stage_id
}

get_package_project_name()
{
	package_project=$(cat build_info | grep TARGET_PRODUCT | tr -d ' ' | cut -d'=' -f2)
	echo -n $package_project
}

download_fail()
{
    echo "..."
    echo "Update image failed"
    echo First run err_handle.sh
    echo Then use update_image.sh
    echo "Finally, If there is still any problem after running err_handle,You Can contact BSP Project Team for help"
    echo ====================
    echo Download failed
    echo ====================
    exit 1
}

# ======================= update fastboot cmd ==================================
FB1=""
if [ "$1" != "" ];then
    FB1="-s ""$1"
fi
FB=${FB}${FB1}
echo check fastboot cmd
sudo $FB getvar product
if [ $? != 0 ]; then
    FB="./fastboot "
    sudo $FB getvar product
    if [ $? != 0 ]; then
        echo Usage ./update_image.sh [SSN_NUM]
        download_fail
    fi
fi
echo fastbot cmd : $FB
# ======================= end update fastboot cmd ===============================

if [ -z $PACKAGE_VARIANT ];then
	PACKAGE_VARIANT=$(get_package_info TARGET_BUILD_VARIANT)
fi

if [ -z $PROJECT_VERSION ];then
	PROJECT_VERSION1=$(get_package_info PROJECT_BUILD_VERSION | awk -F '.' '{print $1}')
    PROJECT_VERSION2=$(get_package_info PROJECT_BUILD_VERSION | awk -F '.' '{print $2}')
    PROJECT_VERSION3=$(get_package_info PROJECT_BUILD_VERSION | awk -F '.' '{print $3}')
    PROJECT_VERSION4=$(get_package_info PROJECT_BUILD_VERSION | awk -F '.' '{print $4}')
fi

PACKAGE_TARGET_SKU=$(get_package_info TARGET_SKU)
PROJECT_NAME=$(get_project_name)
STAGE_ID=$(get_stage_id)
IMAGE_PROJECT_NAME=$(get_package_project_name)

echo "================================================"
echo "package version: $PACKAGE_VARIANT"
echo "project name:    $PROJECT_NAME"
echo "stage id:        $STAGE_ID"
echo "package sku:     $PACKAGE_TARGET_SKU"
echo "================================================"

if [ "$1" == "oneslot" ];then
    echo "flash only slot A"
fi

if [ "$PROJECT_NAME" != "$IMAGE_PROJECT_NAME" ]; then
    echo "This image is for ZS620KL, make sure you use the right image!"
    echo "Finally, If there is still any problem,You Can contact BSP Project Team for help"
    download_fail
fi

result1=$(echo $STAGE_ID | grep "${EVB_NAME}")
result2=$(echo $STAGE_ID | grep "${SR_NAME}")
result=${result1}${result2}
if [ "$result" == "" ]&&[ "$PROJECT_VERSION1" -le "80" ]&&[ "$PROJECT_VERSION2" -le "1" ]&&[ "$PROJECT_VERSION3" -le "2" ]&&[ "$PROJECT_VERSION4" -le "86" ]; then
    echo "Image is too old, please update"
    echo "You Can contact BSP Project Team for help"
	download_fail
fi

echo "flash image now"
echo "================================================"

function GetProject()
{
	#sudo $FB getvar project 2>&1 | grep "project" | grep -q "ZS620KL"
	if [ $? -eq 0 ]; then
		project=ZS620KL
	fi
	project=ZS620KL
	#sudo $FB getvar project 2>&1
}

GetProject

if [ -n "$project" ]; then
	echo Current project type is $project
else
	echo "cannot get project!!!error!!!"
	download_fail
fi 

# ======================= partition_0 ============================
#echo "Erase LUN 0"
#sudo $FB oem erase LUN 0
#if [ $? != 0 ]; then
#    download_fail
#fi

#echo "Flash GPT 0"
#sudo $FB flash partition:0 gpt_both0.bin
#if [ $? != 0 ]; then
#    download_fail
#fi

# ======================= flash: persist ================================
#echo "Start Flash persist"
#sudo $FB erase persist > /dev/null 2>&1
#sudo $FB flash persist persist.img
#if [ $? != 0 ]; then
#    download_fail
#fi

# ======================= erase: misc ================================
echo "Start erase misc"
sudo $FB erase misc > /dev/null 2>&1
if [ $? != 0 ]; then
    download_fail
fi

# ======================= erase: ssd ================================
echo "Start erase ssd"
sudo $FB erase ssd > /dev/null 2>&1
if [ $? != 0 ]; then
    download_fail
fi

:<<!
# ======================= erase: keystore ================================
echo "Start erase keystore"
sudo $FB erase keystore > /dev/null 2>&1
if [ $? != 0 ]; then
    download_fail
fi

# ======================= erase: frp ================================
echo "Start erase frp"
sudo $FB erase frp > /dev/null 2>&1
if [ $? != 0 ]; then
    download_fail
fi
!
# ======================= flash: xrom ================================
echo "Start Flash xrom"
if [ -a "xrom.img" ];then
sudo $FB erase xrom_a > /dev/null 2>&1
sudo $FB flash xrom_a xrom.img
if [ $? != 0 ]; then
    download_fail
fi
else
echo "without xrom image"
fi
# ======================= flash: system ================================
echo "Start Flash system"
sudo $FB erase system_a > /dev/null 2>&1
sudo $FB flash system_a system.img
if [ $? != 0 ]; then
    download_fail
fi
sudo $FB erase system_b > /dev/null 2>&1
sudo $FB flash system_b system_other.img
if [ $? != 0 ]; then
    download_fail
fi

# ======================= partition_1 ============================
#if [ "$result" != "" ]; then
#    echo "Erase LUN 1"
#    sudo $FB oem erase LUN 1
#    if [ $? != 0 ]; then
#        download_fail
#    fi

#    echo "Flash GPT 1"
#    sudo $FB flash partition:1 gpt_both1.bin
#    if [ $? != 0 ]; then
#        download_fail
#    fi
#fi
# ======================= flash: xbl_a ================================
echo "Start Flash xbl_a & xbl_config_a"
sudo $FB flash xbl_a firmware/xbl.elf
if [ $? != 0 ]; then
    download_fail
fi

sudo $FB flash xbl_config_a firmware/xbl_config.elf
if [ $? != 0 ]; then
    download_fail
fi

# ======================= partition_2 ============================
#if [ "$result" != "" ]; then
#    echo "Erase LUN 2"
#    sudo $FB oem erase LUN 2
#    if [ $? != 0 ]; then
#        download_fail
#    fi

#    echo "Flash GPT 2"
#    sudo $FB flash partition:2 gpt_both2.bin
#    if [ $? != 0 ]; then
#        download_fail
#    fi
#fi
# ======================= flash: xbl_b ================================
echo "Start Flash xbl_b & xbl_config_b"
sudo $FB flash xbl_b firmware/xbl.elf
if [ $? != 0 ]; then
    download_fail

fi
sudo $FB flash xbl_config_b firmware/xbl_config.elf
if [ $? != 0 ]; then
    download_fail
fi

# ======================= partition_3 ============================
if [ "$result" != "" ]; then
    echo "Erase LUN 3"
    sudo $FB oem erase LUN 3
    if [ $? != 0 ]; then
        download_fail
    fi

    echo "Flash GPT 3"
    sudo $FB flash partition:3 gpt_both3.bin
    if [ $? != 0 ]; then
        download_fail
    fi
fi

# ======================= partition_4 ============================
#echo "Erase LUN 4"
#sudo $FB oem erase LUN 4
#if [ $? != 0 ]; then
#    download_fail
#fi

#echo "Flash GPT 4"
#sudo $FB flash partition:4 gpt_both4.bin
#if [ $? != 0 ]; then
#    download_fail
#fi

# ======================= A/B partition =====================
# ======================= flash: aop =====================================
echo "Start Flash aop"
sudo $FB flash aop_a firmware/aop.mbn
if [ $? != 0 ]; then
    download_fail
fi
sudo $FB flash aop_b firmware/aop.mbn
if [ $? != 0 ]; then
    download_fail
fi

# ======================= flash: TZ =====================================
echo "Start Flash TZ"
sudo $FB flash tz_a firmware/tz.mbn
if [ $? != 0 ]; then
    download_fail
fi
sudo $FB flash tz_b firmware/tz.mbn
if [ $? != 0 ]; then
    download_fail
fi

# ======================= flash: hyp =====================================
echo "Start Flash hyp"
sudo $FB flash hyp_a firmware/hyp.mbn
if [ $? != 0 ]; then
    download_fail
fi
sudo $FB flash hyp_b firmware/hyp.mbn
if [ $? != 0 ]; then
    download_fail
fi

# ======================= flash: Modem ==================================
echo "Start Flash Modem"
if [ "$result" != "" ]; then
    sudo $FB flash modem_a NON-HLOS.bin
else
    sudo $FB flash modem_a firmware/NON-HLOS.bin
fi
if [ $? != 0 ]; then
    download_fail
fi
if [ "$result" != "" ]; then
    sudo $FB flash modem_b NON-HLOS.bin
else
    sudo $FB flash modem_b firmware/NON-HLOS.bin
fi
if [ $? != 0 ]; then
    download_fail
fi

# ======================= flash: btfm ==================================
echo "Start Flash BTFM"
sudo $FB flash bluetooth_a firmware/BTFM.bin
if [ $? != 0 ]; then
    download_fail
fi
sudo $FB flash bluetooth_b firmware/BTFM.bin
if [ $? != 0 ]; then
    download_fail
fi

# ======================= flash: abl ==================================
echo "Start Flash abl"
sudo $FB flash abl_a abl.elf
if [ $? != 0 ]; then
    download_fail
fi
sudo $FB flash abl_b abl.elf
if [ $? != 0 ]; then
    download_fail
fi

# ======================= flash: dsp ==================================
echo "Start Flash dsp"
sudo $FB flash dsp_a firmware/dspso.bin
if [ $? != 0 ]; then
    download_fail
fi
sudo $FB flash dsp_b firmware/dspso.bin
if [ $? != 0 ]; then
    download_fail
fi

# ======================= flash: keymaster ===================
echo "Start Flash keymaster"
sudo $FB flash keymaster_a firmware/keymaster64.mbn
if [ $? != 0 ]; then
    download_fail
fi
sudo $FB flash keymaster_b firmware/keymaster64.mbn
if [ $? != 0 ]; then
    download_fail
fi

# ======================= flash: Kernel =================================
echo "Start Flash boot"
sudo $FB erase boot_a > /dev/null 2>&1
sudo $FB flash boot_a boot.img
if [ $? != 0 ]; then
    download_fail
fi

# ======================= flash: cmnlib ==========================
echo "Start Flash cmnlib"
sudo $FB flash cmnlib_a firmware/cmnlib.mbn
if [ $? != 0 ]; then
    download_fail
fi
sudo $FB flash cmnlib_b firmware/cmnlib.mbn
if [ $? != 0 ]; then
    download_fail
fi

# ======================= flash: cmnlib64 =====================
echo "Start Flash cmnlib64"
sudo $FB flash cmnlib64_a firmware/cmnlib64.mbn
if [ $? != 0 ]; then
    download_fail
fi
sudo $FB flash cmnlib64_b firmware/cmnlib64.mbn
if [ $? != 0 ]; then
    download_fail
fi

# ======================= flash: devcfg =========================
echo "Start Flash devcfg"
sudo $FB flash devcfg_a firmware/devcfg.mbn
if [ $? != 0 ]; then
    download_fail
fi
sudo $FB flash devcfg_b firmware/devcfg.mbn
if [ $? != 0 ]; then
	    download_fail
fi

# ======================= flash: qupfw =========================
echo "Start Flash qupfw"
sudo $FB flash qupfw_a firmware/qupv3fw.elf
if [ $? != 0 ]; then
    download_fail
fi
sudo $FB flash qupfw_b firmware/qupv3fw.elf
if [ $? != 0 ]; then
	    download_fail
fi

# ======================= flash: vendor =================================
echo "Start Flash Vendor"
sudo $FB erase vendor_a > /dev/null 2>&1
sudo $FB flash vendor_a vendor.img
if [ $? != 0 ]; then
    download_fail
fi

# ======================= flash: vbmeta =================================
echo "Start Flash vbmeta"
sudo $FB erase vbmeta_a > /dev/null 2>&1
sudo $FB flash vbmeta_a vbmeta.img
if [ $? != 0 ]; then
    download_fail
fi
sudo $FB erase vbmeta_b > /dev/null 2>&1
sudo $FB flash vbmeta_b vbmeta.img
if [ $? != 0 ]; then
    download_fail
fi

# ======================= flash: dtbo =================================
echo "Start Flash dtbo"
sudo $FB erase dtbo_a > /dev/null 2>&1
sudo $FB flash dtbo_a dtbo.img
if [ $? != 0 ]; then
    download_fail
fi

# ======================= flash: storsec=========================
echo "Start Flash storsec"
sudo $FB flash storsec_a firmware/storsec.mbn
if [ $? != 0 ]; then
    download_fail
fi
sudo $FB flash storsec_b firmware/storsec.mbn
if [ $? != 0 ]; then
	    download_fail
fi
# ======================= flash: ImageFv =====================================
echo "Start Flash ImageFv"
sudo $FB flash ImageFv_a firmware/imagefv.elf
if [ $? != 0 ]; then
    download_fail
fi
sudo $FB flash ImageFv_b firmware/imagefv.elf
if [ $? != 0 ]; then
    download_fail
fi
# ======================= non A/B partition =====================
# ======================= flash: apdp & msadp ======================================
if [ "$PACKAGE_VARIANT" = "$MARCO_PACKAGE_VARIANT_USER" ]; then
	echo "================================================"
	echo "Shipping user Build, So Erase apdp & msadp "
	echo "================================================"
	sudo $FB erase apdp
	sudo $FB erase msadp
else
	echo "================================================"
	echo "Non User Build, So Start Flash apdp & msadp"
	echo "================================================"
	sudo $FB erase apdp > /dev/null 2>&1
	sudo $FB flash apdp apdp.mbn
	if [ $? != 0 ]; then
 	   download_fail
	fi
	sudo $FB erase msadp > /dev/null 2>&1
	sudo $FB flash msadp msadp.mbn
	if [ $? != 0 ]; then
 	   download_fail
	fi
fi
:<< EOF
# ======================= flash: splash =====================================
echo "Start Flash splash"
sudo $FB erase splash > /dev/null 2>&1
sudo $FB flash splash ./splash.bin
if [ $? != 0 ]; then
    download_fail
fi
EOF
# ======================= flash: logfs =====================================
echo "Start Flash logfs"
sudo $FB flash logfs firmware/logfs_ufs_8mb.bin
if [ $? != 0 ]; then
    download_fail
fi
#================== partition_5 ============================
if [ "$result" != "" ]; then
    echo "Erase LUN 5"
    sudo $FB oem erase LUN 5
    if [ $? != 0 ]; then
        download_fail
    fi

    echo "Flash GPT 5"
    sudo $FB flash partition:5 gpt_both5.bin
    if [ $? != 0 ]; then
        download_fail
    fi
fi

# ======================= format: userdata ===========================
echo "format userdata ...."
sudo $FB erase userdata
if [ $? != 0 ]; then
    download_fail
fi

sudo $FB format:ext4 userdata
if [ $? != 0 ]; then
    download_fail
fi

# ======================= format: factory ===========================
if [ "$result" != "" ]; then
    #sudo $FB reboot-bootloader
    echo "format factory ...."
    sudo $FB format:ext4 factory
    if [ $? != 0 ]; then
        download_fail
    fi
fi
# =================================================================

# ======================= reset active ===========================
echo "set active slot a"
sudo $FB set_active a
if [ $? != 0 ]; then
    download_fail
fi

# =================================================================
echo ====================
echo "Download Complete !"
echo ====================
echo Press any key to continue, system will reboot.
read
sudo $FB reboot
