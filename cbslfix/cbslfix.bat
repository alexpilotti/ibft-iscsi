@echo off

rem Cloudbase Solution Labs
rem iSCSI Boot Fix
rem v1.0 / 20150325
rem Sergiu Strat <sstrat@cloudbasesolutions.com>

if [%1]==[] goto usage
if [%2]==[] goto usage

set offwin=%2
set odir=L:
set logsrv=%1

echo -net iscsi init
wpeutil initializenetwork
echo ---

echo -ping test
ping -w 250 -4 %1
echo ---

echo -map drive
set cmd2run=net use L: \\%logsrv%\logs /user:cbsl /persistent:no bigP4$$w0rd
rem echo %cmd2run%
%cmd2run%
rem net use delete *
echo ---

echo -ntp service
net start w32time
echo -ntp server
%offwin%\system32\w32tm /config /manualpeerlist:pool.ntp.org /syncfromflags:manual /update
echo -ntp sync
%offwin%\system32\w32tm /resync
echo ---

rem set dateid=%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%
rem echo %dateid%

set cmd2run=wmic os get localdatetime /format:csv
for /f "skip=2 tokens=2 delims=," %%q in ('%cmd2run%') do (set "tmp=%%q")
set dateid=%tmp:~0,14%
echo -dateid: %dateid%

rem wmic csproduct get vendor,version,identifyingnumber,uuid /format:csv
set cmd2run=wmic bios get serialnumber /format:csv
for /f "skip=2 tokens=2 delims=," %%q in ('%cmd2run%') do (set "serial=%%q")
set serial=%serial: =%
echo -serial: %serial%

set odir=%odir%\%serial%-%dateid%
echo -odir: %odir%

mkdir %odir%
echo ---

echo -system info
echo %serial% > %odir%\serial.txt
ipconfig /all > %odir%\%serial%-ipconfig.txt
route print /all > %odir%\%serial%-routes.txt
%offwin%\system32\systeminfo /fo list > %odir%\%serial%-systeminfo.txt
%offwin%\system32\systeminfo /fo csv > %odir%\%serial%-systeminfo.csv
echo ---

echo -ibft dump
ibftdump %odir%\%serial%-ibft.bin
rem newline fix
echo.
echo ---

echo -iscsi fix
iscsims %offwin% > %odir%\%serial%-iscsi.log
type %odir%\%serial%-iscsi.log 
echo ---

rem openssh\scp -r %odir% cbsl@%logsrv%:

dir %odir%

goto end

:usage
echo Usage: %0 remoteMapDriveIP offlineWinDir
exit /B 1

:end
