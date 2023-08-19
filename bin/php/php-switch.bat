@echo off
setlocal EnableDelayedExpansion

set "laragonDir=C:/laragon"
set "baseName=php"
set "index=0"

REM Get directories list (excluding the directory with name equal to baseName)
cd /d "%~dp0"
for /d %%A in (*) do (
  if /i "%%A" neq "%baseName%" (
    set /A "index+=1"
    set "dir[!index!]=%%A"
    echo [!index!] %%A
  )
)

:ask_version
REM Ask for version input
set /P "version=Select version: "

REM Validate input
if not defined dir[%version%] (
  echo Invalid version input!
  goto ask_version
)

REM Create junction dir and reload laragon to generate php.ini
rmdir /s /q %baseName%
mklink /j %baseName% "!dir[%version%]!" || pause
start "" "%laragonDir%\laragon.exe" reload php

REM Replace extension_dir line in php.ini
set "iniPath=%baseName%\php.ini"
set "newLine=extension_dir = \"ext\""
set "replacePattern=extension_dir =  \"%laragonDir%/bin/php/php/ext\""
powershell -Command "(Get-Content '%iniPath%') -replace '%replacePattern%', '%newLine%' | Set-Content '%iniPath%'"

endlocal
