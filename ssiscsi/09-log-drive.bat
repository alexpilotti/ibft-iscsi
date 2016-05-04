@echo off

if [%1]==[] goto usage
if [%2]==[] goto usage
if [%3]==[] goto usage

set letter=%1
set logsrv=%2
set share=%3

ping -w 250 -4 %logsrv%
net use %letter:~0,1%: \\%logsrv%\%share% /persistent:no

goto end

:usage
echo Usage: %0 driveLetter remoteMapDriveIP shareName
exit /b 1

:end
