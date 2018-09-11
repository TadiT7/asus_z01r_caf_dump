@set FB=fastboot
%FB% devices > devices_list.txt
for /f "tokens=1 usebackq" %%a in ("devices_list.txt") do ( call start update_image.bat %%a)