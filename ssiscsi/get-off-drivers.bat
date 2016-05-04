@echo off

if [%1]==[] goto usage

set offwin=%1
set ltrwin=%offwin:~0,3%
set dirwin=%offwin:~3%

dism /image:%ltrwin% /windir:%dirwin% /get-drivers /format:table

goto end

:usage
echo Usage: %0 offlineWinDirFullPath
exit /b 1

:end
