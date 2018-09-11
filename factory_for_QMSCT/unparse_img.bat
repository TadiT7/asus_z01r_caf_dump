@echo off
setlocal enabledelayedexpansion
@echo on

@echo ===================================================
@echo "move firmware"
@echo ===================================================
for /f "tokens=*" %%i in ('dir ..\firmware\ /b') do (
move "..\firmware\%%i" "..\"
)

rd ..\firmware

@echo ===================================================
@echo "move modem"
@echo ===================================================
for /f "tokens=*" %%i in ('dir ..\modem\ /b') do (
move "..\modem\%%i" "..\"
)
rd ..\modem

@echo ===================================================
@echo "copy factory_for_QMSCT"
@echo ===================================================

for /f "tokens=*" %%i in ('dir .\ /b') do (
copy ".\%%i" "..\"
)


cd ..\
python checksparse.py -i rawprogram0.xml -o rawprogram_unsparse0.xml -s .\ > nul 2>&1
python checksparse.py -i rawprogram4.xml -o rawprogram_unsparse4.xml -s .\ > nul 2>&1
del system.img
del vendor.img
del persist.img
del userdata.img
del update_image.bat
del update_image.sh

@echo press any key to continue...
@pause
