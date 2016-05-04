@echo off

rem Cloudbase Solution Labs
rem Compare Registry Hives
rem v1.0 / 20160331
rem Sergiu Strat <sstrat@cloudbasesolutions.com>

if [%1]==[] goto usage
if [%2]==[] goto usage
if [%3]==[] goto usage

set hived=%1
set hive1=%2
set hive2=%3

echo -compare registry hives

echo -import hive %hive1%
reg load HKLM\_%hive1% %hived%\%hive1%.hive

echo -import hive %hive2%
reg load HKLM\_%hive2% %hived%\%hive2%.hive

echo -export only differences
reg compare HKLM\_%hive1% HKLM\_%hive2% /s /od > %hived%\diff.%hive1%.%hive2%.log

echo -unload %hive1%
reg unload HKLM\_%hive1%

echo -unload %hive2%
reg unload HKLM\_%hive2%

goto end

:usage
echo Usage: %0 hiveDir hive1 hive2
exit /b 1

:end
