@echo off

rem  Init the portable environment.

set MYCONF=%~dp0

rem  The `MYHOME` dir can be anywhere, e.g. on an external drive, but it must
rem  contain some dir sctructure (see the checks below). So we determine it
rem  corresponding to that structure as the abs path to the `%MYCONF%\..\..`
for %%i in (%MYCONF%..) do (
  set MYHOME=%%~dpi
)

set SCRIPTS_PATH=%MYHOME%config\myconf\windows\scripts

rem  Check that the PATH does not contains the "myconf" yet. This prevents a
rem  path dublicates on repeated calls.
if "%PATH:myconf=%"=="%PATH%" (
  set PATH=%PATH%;%SCRIPTS_PATH%
)

rem  Setting the PATH is not working for these.
set PYTHON=%MYHOME%app\run\python\python.exe
set POWERSHELL=%WINDIR%\System32\WindowsPowerShell\v1.0\powershell.exe


rem --- Check the required dir structure of the MYHOME -----------------------

setlocal

set CONFIG_DIR=%MYHOME%config
set MYCONF_DIR=%CONFIG_DIR%\myconf
set APP_DIR=%MYHOME%app
set RUN_DIR=%APP_DIR%\run

set /a err=0

for %%i in (%CONFIG_DIR%,%MYCONF_DIR%,%APP_DIR%,%RUN_DIR%) do (
  if not exist %%i (
    echo [init] Not found: %%i
    set /a err=1
    goto :END
  )
)

:END
rem  The `endlocal` will be implicitly called on exit.
rem  The `if ... (exit ...)` brokes the `call init || [do on init err]`.
exit /b %err%
