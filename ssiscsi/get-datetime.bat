@echo off

:: localdatetime != currenttime
rem set cmd2run=wmic os get localdatetime /format:value
rem for /f "eol= tokens=2 delims==" %%i in ('%cmd2run%') do set tmp=%%i
rem set datetime=%tmp:~0,14%
rem echo %datetime%

:: no padding zeros
rem set datetime=%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%

:: simple padding
set d_yyyy=%DATE:~10,4%
set d_mm=00%DATE:~4,2%
set d_dd=00%DATE:~7,2%
set t_hh=00%TIME:~0,2%
set t_mm=00%TIME:~3,2%
set t_ss=00%TIME:~6,2%

set d_mm=%d_mm:~-2%
set d_dd=%d_dd:~-2%
set t_hh=%t_hh:~-2%
set t_mm=%t_mm:~-2%
set t_ss=%t_ss:~-2%

set datetime=%d_yyyy%%d_mm%%d_dd%%t_hh%%t_mm%%t_ss%

echo %datetime%
