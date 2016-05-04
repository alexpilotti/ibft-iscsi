@echo off

rem Cloudbase Solution Labs
rem Drivers Dump
rem v1.0 / 201503
rem Sergiu Strat <sstrat@cloudbasesolutions.com>

if [%1]==[] goto usage
if [%2]==[] goto usage

set windir=%1
set outdir=%2
set suffix=%3

echo -dism 3rd party drivers
cmd /c get-off-drivers.bat %windir% > %outdir%\dism-drivers%suffix%.log
type %outdir%\dism-drivers%suffix%.log
echo ---

goto end

:usage
echo Usage: %0 winDir outDir [suffix]
exit /b 1

:end
