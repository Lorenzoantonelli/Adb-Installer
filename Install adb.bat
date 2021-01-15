cd /d "%~dp0"
@ECHO OFF & CLS & ECHO.
title Adb Installer
color 97

:init
 setlocal DisableDelayedExpansion
 set cmdInvoke=1
 set winSysFolder=System32
 set "batchPath=%~0"
 for %%k in (%0) do set batchName=%%~nk
 set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
 setlocal EnableDelayedExpansion

:checkPrivileges
  NET FILE 1>NUL 2>NUL
  if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
  if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)

  ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
  ECHO args = "ELEV " >> "%vbsGetPrivileges%"
  ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
  ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
  ECHO Next >> "%vbsGetPrivileges%"

  if '%cmdInvoke%'=='1' goto InvokeCmd 

  ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
  goto ExecElevation

:InvokeCmd
  ECHO args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
  ECHO UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"

:ExecElevation
 "%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
 exit /B

:gotPrivileges
 setlocal & cd /d %~dp0
 if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

 REM

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
xcopy /s /q /y "resources\adb-files\*.*" "%CD:~0,3%\adb\"
SETX PATH "%PATH%;%CD:~0,3%\adb" /m
set ADB=System-Wide.

:choice2
set /P c=Do you want to install latest drivers[Y/N]?
if /I "%c%" EQU "Y" goto drivers
if /I "%c%" EQU "N" goto exit
if /I "%c%" EQU "y" goto drivers
if /I "%c%" EQU "n" goto exit

:drivers
pnputil -i -a resources\drivers\*.inf

:exit
echo Adb successfully installed!
pause
exit
