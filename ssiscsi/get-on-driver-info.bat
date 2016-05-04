@echo off

if [%1]==[] goto usage

dism /online /get-driverinfo /driver:%1

goto end

:usage
echo Usage: %0 infFileName
exit /b 1

:end
