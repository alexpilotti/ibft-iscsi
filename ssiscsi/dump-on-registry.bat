@echo off

rem Cloudbase Solution Labs
rem Registry Dump
rem v1.0 / 20160330
rem Sergiu Strat <sstrat@cloudbasesolutions.com>

if [%1]==[] goto usage

set outdir=%1

set key=HKLM\SYSTEM\ControlSet001\Control\DeviceLocations
echo -list device localtions
reg query %key%

echo -export device locations
reg export %key% %outdir%\device-locations.reg /y

goto end

:usage
echo Usage: %0 outDir
exit /b 1

:end
