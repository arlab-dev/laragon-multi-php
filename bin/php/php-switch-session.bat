@echo off
setlocal EnableDelayedExpansion

set "phpDir=C:\laragon\bin\php\"
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

echo set "PATH=%phpDir%!dir[%version%]!;%%PATH%%"

endlocal