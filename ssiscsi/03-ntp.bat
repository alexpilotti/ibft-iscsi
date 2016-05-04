@echo off

if [%1]==[] goto usage
set offwin=%1

echo setting timezone to UTC
%offwin%\system32\tzutil /s utc

net start w32time 2>NUL

%offwin%\system32\w32tm /tz
%offwin%\system32\w32tm /config /manualpeerlist:pool.ntp.org /syncfromflags:manual /update
%offwin%\system32\w32tm /resync

echo.
wmic os get localdatetime

echo OS Time
date /t
time /t

goto end

:usage
echo Usage: %0 offlineWinDir
exit /b 1

:end
