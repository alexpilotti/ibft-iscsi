@echo off

rem Cloudbase Solution Labs
rem System Dump
rem v1.0 / 20160331
rem Sergiu Strat <sstrat@cloudbasesolutions.com>

if [%1]==[] goto usage
if [%2]==[] goto usage

set windir=%1
set logdir=%2
set suffix=%3

for /f %%i in ('get-id') do set id=%%i

set outdir=%logdir%\%id%
echo outdir %outdir%

mkdir %outdir%

cmd /c dump-off-system.bat %windir% %outdir%
cmd /c dump-off-drivers.bat %windir% %outdir% %suffix%
cmd /c dump-off-registry.bat %windir% %outdir% %suffix%
cmd /c dump-ibft.bat %outdir%

dir %outdir%

goto end

:usage
echo Usage: %0 winDir logBaseDir [suffix]
exit /b 1

:end
