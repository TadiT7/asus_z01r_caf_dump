@echo off

REM ============== USAGE ==============
REM flashall_AFT.cmd [Format option] [SN number]
REM 	[Format option]:	1=enable, 0=disable. default=1
REM 							Format userdata/cache
REM 	[SN number]:		device SN number
REM 							Support multiple download image

set /a a=1
:loop
@set DATAERASE=data_erase
@if [%1] NEQ [0] goto step1
@set DATAERASE=non_data_erase

:step1
@if [%2] EQU [] (@set fb=no_ssn
goto step2 )

fastboot devices | findstr "\<%2\>"
IF %ERRORLEVEL% NEQ 0 goto Error
@set SSN=%2

:step2
echo SSN:%SSN%
call update_image.bat %DATAERASE% %SSN%
@ECHO OFF
IF %ERRORLEVEL% NEQ 0 goto Error
@ECHO ON
@exit /b 0

:Error
set /a a=%a%+1
if %a% LEQ 2 (  echo *******************************************************************************
				echo                 Now,we will try it again!!!
				echo *******************************************************************************
				goto loop )
else ( echo Update image failed!!! )
@exit /b 1
