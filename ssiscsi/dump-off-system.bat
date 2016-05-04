@echo off

rem Cloudbase Solution Labs
rem System Dump
rem v1.0 / 201503
rem Sergiu Strat <sstrat@cloudbasesolutions.com>

if [%1]==[] goto usage
if [%2]==[] goto usage

set windir=%1
set outdir=%2

echo -serial
for /f %%i in ('get-serial') do set serial=%%i
echo %serial%
echo %serial% > %outdir%\serial.txt

echo -networking
ipconfig /all > %outdir%\ipconfig.txt
route print > %outdir%\routes.txt

echo -systeminfo
%windir%\system32\systeminfo /fo list > %outdir%\systeminfo.txt
echo ---

goto end

:usage
echo Usage: %0 winDir outDir
exit /b 1

:end
