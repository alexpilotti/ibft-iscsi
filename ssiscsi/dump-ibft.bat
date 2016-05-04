@echo off

rem Cloudbase Solution Labs
rem iBFT Dump
rem v1.0 / 20160331
rem Sergiu Strat <sstrat@cloudbasesolutions.com>

if [%1]==[] goto usage

set outdir=%1

echo -ibft
ibftdump %outdir%\ibft.bin
rem ibftdump -pretty %outdir%\ibft.bin
rem newline fix
echo.
echo ---

goto end

:usage
echo Usage: %0 outDir
exit /b 1

:end
