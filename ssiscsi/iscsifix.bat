@echo off

rem Cloudbase Solution Labs
rem System Dump
rem v1.0 / 20160331
rem Sergiu Strat <sstrat@cloudbasesolutions.com>

if [%1]==[] goto usage
if [%2]==[] goto usage

set windir=%1
set outdir=%2
set suffix=%3

iscsims.exe > %outdir%\iscsi-fix%suffix%.log
type %outdir%\iscsi-fix%suffix%.log

goto end

:usage
echo Usage: %0 winDir outDir [suffix]
exit /b 1

:end
