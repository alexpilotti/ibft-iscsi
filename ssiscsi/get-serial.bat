@echo off

set cmd2run=wmic bios get serialnumber /format:value
for /f "eol= tokens=2 delims==" %%i in ('%cmd2run%') do set tmp=%%i
set serial=%tmp: =%
echo %serial%
