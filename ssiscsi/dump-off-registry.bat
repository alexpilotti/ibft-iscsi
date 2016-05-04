@echo off

rem Cloudbase Solution Labs
rem Registry Dump
rem v1.0 / 20160331
rem Sergiu Strat <sstrat@cloudbasesolutions.com>

if [%1]==[] goto usage
if [%2]==[] goto usage

set windir=%1
set outdir=%2
set suffix=%3

echo system hive backup
copy %windir%\system32\config\system %outdir%\system%suffix%.hive

echo -registry
echo -import hive copy
reg load HKLM\iscsi %outdir%\system%suffix%.hive
set key=HKLM\iscsi\ControlSet001\Control\DeviceLocations

echo -device localtions
reg query %key%

echo -export device locations
reg export %key% %outdir%\device-locations%suffix%.reg /y

echo -unload hive
reg unload HKLM\iscsi

goto end

:usage
echo Usage: %0 winDir outDir [suffix]
exit /b 1

:end
