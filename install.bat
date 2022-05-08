@echo off

rem  Using:
rem
rem    install [script]
rem
rem  Inits env vars, then runs:
rem
rem    %MYCONF%\windows\scripts\install\[script] 

call "%~dp0init.bat" || goto :EOF

setlocal

set script=%~1
call "%MYCONF%windows\scripts\install\%script%"

endlocal
