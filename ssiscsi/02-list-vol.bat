@echo off

diskpart /s %0.script
echo.

rem wmic logicaldisk get /format:value
wmic diskdrive get caption,index,size /format:table 
wmic logicaldisk get deviceid,description,filesystem,volumename,size /format:table 
