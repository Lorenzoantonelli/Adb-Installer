cd /d "%~dp0"
@echo off
title 15 seconds Adb installer
color 97

:choice
set /P c=Do you want to install Adb System-wide[Y/N]?
if /I "%c%" EQU "Y" goto checkadb
if /I "%c%" EQU "N" goto choice2
if /I "%c%" EQU "y" goto checkadb
if /I "%c%" EQU "n" goto choice2

:checkadb
IF NOT EXIST %CD:~0,3%\adb\ GOTO install
RD /S /Q %CD:~0,3%\adb


:install
mkdir %CD:~0,3%\adb
xcopy /s /q /y "adb\*.*" "%CD:~0,3%\adb\"
SETX PATH "%PATH%;%CD:~0,3%\adb" /m
set ADB=System-Wide.

:choice2
set /P c=Do you want to install latest drivers[Y/N]?
if /I "%c%" EQU "Y" goto drivers
if /I "%c%" EQU "N" goto exit
if /I "%c%" EQU "y" goto drivers
if /I "%c%" EQU "n" goto exit

:drivers
pnputil -i -a drivers\*.inf

:exit
echo Adb successfully installed!
pause
exit
