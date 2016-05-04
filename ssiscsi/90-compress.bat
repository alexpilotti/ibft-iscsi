@echo off

rem Cloudbase Solution Labs
rem Compress Big Files
rem v1.0 / 20160331
rem Sergiu Strat <sstrat@cloudbasesolutions.com>

if [%1]==[] goto usage

set outdir=%1
set suffix=%2

set files=system%suffix%.hive device-locations%suffix%.reg
for %%i in (%files%) do (
	7z\7z a -sdel -tgzip %outdir%\%%i.gz %outdir%\%%i
)

goto end

:usage
echo Usage: %0 outDir [suffix]
exit /b 1

:end
