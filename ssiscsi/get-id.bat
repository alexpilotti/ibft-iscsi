@echo off

for /f %%i in ('get-datetime') do set datetime=%%i
for /f %%i in ('get-serial') do set serial=%%i

set id=%1%serial%-%datetime%%2
echo %id%
