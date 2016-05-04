@echo off

if [%1]==[] goto usage

dism /online /remove-driver /driver:%1

goto end

:usage
echo Usage: %0 infFileName
exit /b 1

:end
