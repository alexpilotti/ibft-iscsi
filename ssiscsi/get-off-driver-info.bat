@echo off

if [%1]==[] goto usage
if [%2]==[] goto usage

set offwin=%1
set ltrwin=%offwin:~0,3%
set dirwin=%offwin:~3%
set driver=%2

dism /image:%ltrwin% /windir:%dirwin% /get-driverinfo /driver:%driver%

goto end

:usage
echo Usage: %0 offlineWinDirFullPath infFileName
exit /b 1

:end
