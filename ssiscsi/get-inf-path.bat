@echo off

if [%1]==[] goto usage
if [%2]==[] goto usage

set windir=%1
set driver=%2

set file=
set cmd2run="dir /b /s %windir%\System32\DriverStore\FileRepository\%driver% 2>NUL"
for /f "usebackq" %%i in (`%cmd2run%`) do if not "%%i"=="" set file=%%i

set cmd2run="dir /b /s %windir%\inf\%driver% 2>NUL"
for /f "usebackq" %%i in (`%cmd2run%`) do if not "%%i"=="" set file=%%i

if not "%file%"=="" (
	echo %file%
	exit /b 0
) else (
	echo %driver% not found!
	exit /b 1
)

goto end

:usage
echo Usage: %0 winDirFullPath infFileName
exit /b 1

:end
