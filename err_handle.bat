::=================MAIN================================================
::=============MARCO_DEFINE===============================
@set FASTBOOT_BIN=fastboot
@set MARCO_PACKAGE_VARIANT_USERDEBUG=userdebug
@set MARCO_PACKAGE_VARIANT_USER=user
@set MARCO_PACKAGE_VARIANT_ENG=eng
:setfb
if "%DEVICE_SSN%" neq "" (
 set FB=%FASTBOOT_BIN% -s %DEVICE_SSN%
) else (
 set FB=%FASTBOOT_BIN%
)
@echo on
@echo Flash GPT 0
@echo %PROJECT%
@%FB% flash partition:0 gpt_both0.bin
@if %ERRORLEVEL% neq 0 (
    goto Error
)

@echo Flash GPT 4
@echo %PROJECT%
@%FB% flash partition:4 gpt_both4.bin
@if %ERRORLEVEL% neq 0 (
    goto Error
)

@%FB% reboot-bootloader
@echo off
for /l %%i in (1,1,5000) do echo %%i>nul
@echo now run update_image.bat

::======= error exit==============================
:Error
@pause
@exit /b 1

