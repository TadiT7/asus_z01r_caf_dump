::=================MAIN================================================
::=============MARCO_DEFINE===============================
@set FASTBOOT_BIN=fastboot
@set MARCO_PACKAGE_VARIANT_USERDEBUG=userdebug
@set MARCO_PACKAGE_VARIANT_USER=user
@set MARCO_PACKAGE_VARIANT_ENG=eng
@set EVB_NAME=EV
@set SR_NAME=SR
::=========Additional Override Define For Input Para Use========
@set MARCO_PACKAGE_VARIANT_FACTORY=fac
@set MARCO_PACKAGE_VARIANT_SHIPPING=shipping
@set SKIP_REBOOT=0
::==============GLOBLE DEFINE=========================================
@set PACKAGE_VARIANT=
@set PROJECT=
@set ERASE_DATA_CACHE=
@set DEVICE_SSN=
@set PACKAGE_TARGET_SKU=
@set UPDATE_SCRIPT_NAME=
@set STAGE_ID=
@set PROJECT_VERSION=
::===========get command form parent caller========================
::usage update_image.bat [-w] [--shipping] [--adb_enable] [--no_ssn]
::-w 			     erase userdata and cache
::shipping         shipping update image
::no_ssn	   update images for single device

:loop_args
@echo off
if "%1" NEQ "" (
  if "%1"=="--shipping" (
	 set PACKAGE_VARIANT=%MARCO_PACKAGE_VARIANT_SHIPPING%
   )
   if "%1"=="--fac" (
    set PACKAGE_VARIANT=%MARCO_PACKAGE_VARIANT_FACTORY%
   )
   if "%1"=="-w" (
     set ERASE_DATA_CACHE=1
   )
   if "%1"=="data_erase" (
     set ERASE_DATA_CACHE=1
   )
   if "%1"=="non_data_erase" (
     set ERASE_DATA_CACHE=0
   )
   if "%1"=="no_ssn" (
     set FB=%FASTBOOT_BIN%
   )
   if "%1"=="--skip" (
     set SKIP_REBOOT=1
   )
   if "%1"=="-s" (
     set DEVICE_SSN=%2
     SHIFT
   )
  SHIFT
  goto loop_args
) else (
 goto setfb
)
:setfb
@if "%DEVICE_SSN%" neq "" (
 @set FB=%FASTBOOT_BIN% -s %DEVICE_SSN%
) else (
 @set FB=%FASTBOOT_BIN%
)
@echo on
@echo check fastboot cmd
@%FB% getvar product
@if %ERRORLEVEL% neq 0 (
    @set FB=%FASTBOOT_BIN%
    @%FB% getvar product
    @if %ERRORLEVEL% neq 0 (
        @echo Usage update_image.bat [-w] [--shipping] [--adb_enable] [--no_ssn] [ssn_num]
        @goto Error
    )
)
@echo fastboot cmd : %FB%
@echo on
::============get package and system information====================
@if "%PACKAGE_VARIANT%" neq "" (goto skip_get_package_info)
@call :get_package_info PACKAGE_VARIANT TARGET_BUILD_VARIANT
:skip_get_package_info
@call :get_package_info PACKAGE_TARGET_SKU TARGET_SKU
@call :get_project_name PROJECT
@call :get_package_project_name PACKAGE_PROJECT
@call :get_stage_id STAGE_ID
@call :get_package_info PROJECT_VERSION PROJECT_BUILD_VERSION

::============echo the package and harware information===============
@echo fastboot:%FB%
@echo package version:%PACKAGE_VARIANT%
@echo project name:%PROJECT%
@echo package project name:%PACKAGE_PROJECT%
@echo package sku:%PACKAGE_TARGET_SKU%
@echo stage id:%STAGE_ID%
@echo project build version:%PROJECT_VERSION%

@if "%PACKAGE_VARIANT%"=="%MARCO_PACKAGE_VARIANT_SHIPPING%" (
    @echo Cautious, This is shipping flash route
)
@if "%PACKAGE_VARIANT%"=="%MARCO_PACKAGE_VARIANT_FACTORY%" (
    @echo Cautious, This is factory flash route
)

::===========check project  name and cpu type======================
@if  [%PROJECT%]==[] (
    @echo project name is not recognized
    @goto Error
)

@echo on
@if "%PROJECT%" NEQ "%PACKAGE_PROJECT%" (
    echo This image is for ZS620KL, make sure you use the right image!
    echo Finally, If there is still any problem,You Can contact BSP Project Team for help
	@goto Error
)

@echo on
@set PROJECT_VERSION="%PROJECT_VERSION%"
:SPLIT_VERSION
@for /f "delims=., tokens=1,*" %%i in (%PROJECT_VERSION%) do (
    @set CHECK_VERSION_NUM1=%CHECK_VERSION_NUM2%
    @set CHECK_VERSION_NUM2=%CHECK_VERSION_NUM3%
    @set CHECK_VERSION_NUM3=%CHECK_VERSION_NUM4%
    @set CHECK_VERSION_NUM4=%%i
    @set PROJECT_VERSION="%%j"
    @if "%%j" neq "" (
        @goto SPLIT_VERSION
    )
)

@set STAGE_ID_HEAD=%STAGE_ID:~0,2%
@set /a RESULT_CMP=3
@if "%STAGE_ID_HEAD%" EQU "%EVB_NAME%" (
    @set /a RESULT_CMP=1
)
@if "%STAGE_ID_HEAD%" EQU "%SR_NAME%" (
    @set /a RESULT_CMP=2
)
@if %RESULT_CMP% GEQ 3 (
	@if %CHECK_VERSION_NUM1% LEQ 80 (
        @if %CHECK_VERSION_NUM2% LEQ 1 (
            @if %CHECK_VERSION_NUM3% LEQ 2 (
                @if %CHECK_VERSION_NUM4% LEQ 86 (
                    @echo Image is too old, please update.
                    @echo You Can contact BSP Project Team for help
                    @goto Error
                )
            )
        )
	)
)
::===========erase or flash image ==============================
@echo ===================================================
@echo "flash image now"
@echo ===================================================

:: ======================= flash: partition 0 ===============
::@echo Erase LUN 0
::@%FB% oem erase LUN 0
::@if %ERRORLEVEL% neq 0 (
::    goto Error
::)

::@echo Flash GPT 0
::@echo %PROJECT%
::@%FB% flash partition:0 gpt_both0.bin
::@if %ERRORLEVEL% neq 0 (
::    goto Error
::)

::   @echo flash persist
:: ======================= flash: persist in all mode  ============================
::   @%FB% erase persist > nul 2>&1
::   @%FB% flash persist persist.img
::   	@if %ERRORLEVEL% neq 0 (
::		goto Error
::    )

   @echo erase misc
:: ======================= erase: misc in all mode  ============================
   @%FB% erase misc > nul 2>&1
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

   @echo erase ssd
:: ======================= erase: ssd in all mode  ============================
   @%FB% erase ssd > nul 2>&1
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

   @echo flash system
:: ======================= flash:system in all mode========================================
:: =============need erase before flashing======
    @%FB% erase system_a > nul 2>&1
    @%FB% flash system_a system.img
    @if %ERRORLEVEL% neq 0 (
		goto Error
    )
    @%FB% erase system_b > nul 2>&1
    @%FB% flash system_b system_other.img
    @if %ERRORLEVEL% neq 0 (
		goto Error
    )

   @echo flash xrom
:: ======================= flash:xrom in all mode========================================
:: =============need erase before flashing======
@if exist xrom.img (
    @%FB% erase xrom_a > nul 2>&1
    @%FB% flash xrom_a xrom.img
    @if %ERRORLEVEL% neq 0 (
		goto Error
    )
) else (
    @echo without xrom
)

:: ======================= flash: partition 1 ===============
::@if %RESULT_CMP% LSS 3 (
::    @echo Erase LUN 1
::    @%FB% oem erase LUN 1
::    @if %ERRORLEVEL% neq 0 (
::        goto Error
::    )

::    @echo Flash GPT 1
::    @echo %PROJECT%
::    @%FB% flash partition:1 gpt_both1.bin
::    @if %ERRORLEVEL% neq 0 (
::        goto Error
::    )
::)
   @echo flash xbl_a
:: ======================= flash: XBL & XBL_CONFIG in all mode  ============================
   @%FB% flash xbl_a firmware\xbl.elf
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

   @%FB% flash xbl_config_a firmware\xbl_config.elf
    @if %ERRORLEVEL% neq 0 (
		goto Error
    )

:: ======================= flash: partition 2 ===============
::@if %RESULT_CMP% LSS 3 (
::    @echo Erase LUN 2
::    @%FB% oem erase LUN 2
::    @if %ERRORLEVEL% neq 0 (
::        goto Error
::    )

::    @echo Flash GPT 2
::    @echo %PROJECT%
::    @%FB% flash partition:2 gpt_both2.bin
::    @if %ERRORLEVEL% neq 0 (
::        goto Error
::    )
::)

   @echo flash xbl_b
:: ======================= flash: XBL & XBL_CONFIG in all mode  ============================
   @%FB% flash xbl_b firmware\xbl.elf
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

   @%FB% flash xbl_config_b firmware\xbl_config.elf
    @if %ERRORLEVEL% neq 0 (
		goto Error
    )

:: ======================= flash: partition 3 ===============
@if %RESULT_CMP% LSS 3 (
    @echo Erase LUN 3
    @%FB% oem erase LUN 3
    @if %ERRORLEVEL% neq 0 (
        goto Error
    )

    @echo Flash GPT 3
    @echo %PROJECT%
    @%FB% flash partition:3 gpt_both3.bin
    @if %ERRORLEVEL% neq 0 (
        goto Error
    )
)

:: ======================= flash: partition 4 ===============
::@echo Erase LUN 4
::@%FB% oem erase LUN 4
::@if %ERRORLEVEL% neq 0 (
::    goto Error
::)

::@echo Flash GPT 4
::@echo %PROJECT%
::@%FB% flash partition:4 gpt_both4.bin
::@if %ERRORLEVEL% neq 0 (
::    goto Error
::)

::@echo %PROJECT%
::@%FB% flash partition:4 gpt_both4.bin
::@if %ERRORLEVEL% neq 0 (
::    goto Error
::)
   @echo flash aop
:: ======================= A/B partition ===============================
:: ======================= flash: aop in all mode ===============================
    @%FB% flash aop_a firmware\aop.mbn
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

    @%FB% flash aop_b firmware\aop.mbn
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

   @echo flash tz
:: ======================= flash: TZ in all mode ===============================
    @%FB% flash tz_a firmware\tz.mbn
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

    @%FB% flash tz_b firmware\tz.mbn
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

   @echo flash hyp
:: ======================= flash: hyp in all mode ===============================
    @%FB% flash hyp_a firmware\hyp.mbn
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

    @%FB% flash hyp_b firmware\hyp.mbn
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

   @echo flash modem
:: ======================= flash:Modem in all mode=====================================
:: =============Modem need erase partiting before flashing============
@if %RESULT_CMP% LSS 3 (
    @%FB% flash modem_a NON-HLOS.bin
)else (
    @%FB% flash modem_a firmware\NON-HLOS.bin
)
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

@if %RESULT_CMP% LSS 3 (
    @%FB% flash modem_b NON-HLOS.bin
)else (
    @%FB% flash modem_b firmware\NON-HLOS.bin
)
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

   @echo flash bluetooth
:: ======================= flash: btfm in all mode ===============================
    @%FB% flash bluetooth_a firmware\BTFM.bin
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

    @%FB% flash bluetooth_b firmware\BTFM.bin
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

   @echo flash abl
:: ======================= flash: abl in all mode=======================
    @%FB% flash abl_a abl.elf
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

    @%FB% flash abl_b abl.elf
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

   @echo flash dsp
:: ======================= flash: dsp in all mode ======================================
    @%FB% flash dsp_a firmware\dspso.bin
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

    @%FB% flash dsp_b firmware\dspso.bin
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

   @echo flash keymaster
:: ======================= flash: keymaster in all mode==================
    @%FB% flash keymaster_a firmware\keymaster64.mbn
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

    @%FB% flash keymaster_b firmware\keymaster64.mbn
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

    @echo flash kernel
:: ======================= flash:Kernel in all mode====================================
    @%FB% erase boot_a > nul 2>&1
    @%FB% flash boot_a boot.img
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

    @echo flash cmnlib
:: ======================= flash: cmnlib in all mode========================
    @%FB% flash cmnlib_a firmware\cmnlib.mbn
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

    @%FB% flash cmnlib_b firmware\cmnlib.mbn
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

    @echo flash cmnlib_64
:: ======================= flash: cmnlib64 in all mode====================
    @%FB% flash cmnlib64_a firmware\cmnlib64.mbn
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

    @%FB% flash cmnlib64_b firmware\cmnlib64.mbn
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

    @echo flash devcfg
:: ======================= flash: devcfg in all mode=======================
    @%FB% flash devcfg_a firmware\devcfg.mbn
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

    @%FB% flash devcfg_b firmware\devcfg.mbn
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

   @echo flash qupfw
:: ======================= flash: qupfw in all mode=======================
    @%FB% flash qupfw_a firmware\qupv3fw.elf
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

    @%FB% flash qupfw_b firmware\qupv3fw.elf
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

    @echo flash vendor
:: ======================= flash:vendor in all mode====================================
    @%FB% erase vendor_a > nul 2>&1
    @%FB% flash vendor_a vendor.img
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

    @echo flash vbmeta
:: ======================= flash:vbmeta in all mode====================================
    @%FB% erase vbmeta_a > nul 2>&1
    @%FB% flash vbmeta_a vbmeta.img
    @if %ERRORLEVEL% neq 0 (
		goto Error
    )

    @%FB% erase vbmeta_b > nul 2>&1
    @%FB% flash vbmeta_b vbmeta.img
    @if %ERRORLEVEL% neq 0 (
		goto Error
    )

    @echo flash dtbo
:: ======================= flash:dtbo in all mode====================================
    @%FB% erase dtbo_a > nul 2>&1
    @%FB% flash dtbo_a dtbo.img
    @if %ERRORLEVEL% neq 0 (
		goto Error
    )

    @echo flash storsec
:: ======================= flash: storsec in all mode=======================
    @%FB% flash storsec_a firmware\storsec.mbn
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

    @%FB% flash storsec_b firmware\storsec.mbn
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )
:: ======================= flash: ImageFv in all mode==================
    @%FB% flash ImageFv_a firmware\imagefv.elf
    @if %ERRORLEVEL% neq 0 (
    goto Error
    )
    @%FB% flash ImageFv_b firmware\imagefv.elf
    @if %ERRORLEVEL% neq 0 (
    goto Error
    )
:: ======================= non A/B partition ===============================
    @echo flash apdp
:: ======================= flash:apdp in userdebug, otherwise erase ====================
    @if  "%PACKAGE_VARIANT%"=="%MARCO_PACKAGE_VARIANT_USER%" (
      @%FB% erase apdp
	  @if %ERRORLEVEL% neq 0 (
		goto Error
	  )
    ) else (
      @%FB% erase apdp > nul 2>&1
      @%FB% flash apdp apdp.mbn
	  @if %ERRORLEVEL% neq 0 (
		goto Error
      )
    )

    @echo flash msadp
:: ======================= flash:msadp in userdebug,otherwise erase =====================
    @if  "%PACKAGE_VARIANT%"=="%MARCO_PACKAGE_VARIANT_USER%" (
      @%FB% erase msadp
	  @if %ERRORLEVEL% neq 0 (
		goto Error
      )
    ) else (
      @%FB% erase msadp > nul 2>&1
      @%FB% flash msadp msadp.mbn
	  @if %ERRORLEVEL% neq 0 (
		goto Error
      )
    )
goto skip1
    @echo flash splash
:: ======================= flash: splash in all mode==================
    @%FB% erase splash > nul 2>&1
    @%FB% flash splash splash.bin
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )
:skip1
:: ======================= flash: logfs in all mode==================
    @%FB% flash logfs firmware\logfs_ufs_8mb.bin
   	@if %ERRORLEVEL% neq 0 (
		goto Error
    )

:: ======================= flash: partition 5 ===============
@if %RESULT_CMP% LSS 3 (
    @echo Erase LUN 5
    @%FB% oem erase LUN 5
    @if %ERRORLEVEL% neq 0 (
        goto Error
    )

    @echo Flash GPT 5
    @echo %PROJECT%
    @%FB% flash partition:5 gpt_both5.bin
    @if %ERRORLEVEL% neq 0 (
        goto Error
    )
)

:: ============== special case for factory's full reset =====================================
:: ========== Be Carefull, The Factory.bat will do some erase function .=====================
:: ========== So when moving the line of @call factory.bat %FB% =============================
:: ========== please make sure the factory.bat's erase function take effect first============
:: ========== or the flashing process may be useless ========================================

    @if  "%PACKAGE_VARIANT%"=="%MARCO_PACKAGE_VARIANT_FACTORY%" (
      @call factory.bat %FB%
	  @if %ERRORLEVEL% neq 0 (
    	goto Error
      )
    )

::=====================print success message========================================
@echo "%FB% format userdata"
@echo off
@%FB% erase userdata
@if %ERRORLEVEL% neq 0 (
	@echo fail
	@goto Error
)

@%FB% format:ext4 userdata
@if %ERRORLEVEL% neq 0 (
    @echo fail
    @goto Error
)

@if %RESULT_CMP% LSS 3 (
    @%FB% format:ext4 factory
    @if %ERRORLEVEL% neq 0 (
        @echo fail
        @goto Error
    )
)

::=====================reset active========================================
@echo "set active slot a"
@echo off
@%FB% set_active a
@if %ERRORLEVEL% neq 0 (
	@echo fail
	@goto Error
)

@echo ====================
@echo "Download Complete !"
@echo ====================

::========================end MAIN============================================
@goto :End_MAIN

::=======================functions============================
:: get package information for file buid_info
:: %~1 output, the value return
:: %~2 input, the keyword string to mach
:get_package_info
@echo off
set keyword=%~2
for /f "eol=# delims== tokens=1,2" %%i  in (build_info) do (
    if "%%i"=="%keyword%"   (
    set keyval=%%j
    goto break_in_get_package_info
    )
)
:break_in_get_package_info
set keyval=%keyval: =%
set %~1=%keyval%
@echo on
@goto :eof

::====== function: get_project_name==========
::%~1 output, the value of project
:get_project_name
@echo off
set keyval=
set project_name=
for /f "tokens=1,2" %%i  in ('%FB% getvar product 2^>^&1 ^| findstr product') do (
	set keyval=%%j
	goto break_in_get_project_name
)
:break_in_get_project_name
set keyval=%keyval: =%
set %~1=%keyval%
@echo on
@goto :eof

:get_stage_id
@echo off
set keyval=
for /f "tokens=1,2" %%i  in ('%FB% getvar stage-id 2^>^&1 ^| findstr stage-id') do (
	set keyval=%%j
	goto break_in_stage_id
)
:break_in_stage_id
set keyval=%keyval: =%
set %~1=%keyval%
@echo on
@goto :eof

:get_package_project_name
@echo off
set keyword=TARGET_PRODUCT
set keyval=
set project_name=
for /f "eol=# delims== tokens=1,2" %%i  in (build_info) do (
	if "%%i"=="%keyword%" (
		set keyval=%%j
		goto break_in_get_package_project_name
    )
)
:break_in_get_package_project_name
set keyval=%keyval: =%
if "%keyval%"=="ZS620KL" (
	set project_name=ZS620KL
)
set %~1=%project_name%
@echo on
@goto :eof


::======= succ exit==============================
:End_MAIN
@if %SKIP_REBOOT% neq 0 (
  @goto SKIP_SUCCESS_SHPPING
)
@echo pass
@if "%PACKAGE_VARIANT%"=="%MARCO_PACKAGE_VARIANT_SHIPPING%" goto SKIP_SUCCESS_SHPPING
@echo press any key to continue, system will reboot!
@pause
:SKIP_SUCCESS_PAUSE
@%FB% reboot
:SKIP_SUCCESS_SHPPING
@exit /b 0

::======= Fail in subbat==============================
:FAIL_IN_SUBBAT
@exit /b 1

::======= error exit==============================
:Error
@echo ...
@echo Update image failed
@echo First run err_handle.bat
@echo Then use update_image.bat !
@echo Finally, If there is still any problem after running err_handle,You Can contact BSP Project Team for help
@echo ====================
@echo Download failed
@echo ====================
@if "%PACKAGE_VARIANT%"=="%MARCO_PACKAGE_VARIANT_SHIPPING%" goto SKIP_FAIL_PAUSE
@pause
:SKIP_FAIL_PAUSE
@exit /b 1
