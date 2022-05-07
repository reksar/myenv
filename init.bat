@echo off

rem  Init the portable environment.

rem  Reset error code.
set /a MYERR=0

set MYCONF=%~dp0


rem --- PORTABLE_HOME --------------------------------------------------------

rem  The `PORTABLE_HOME` dir can be anywhere, e.g. on an external drive,
rem  but it must contain some dir sctructure (see the checks below). So we
rem  determine it corresponding to that structure as the abs path of the
rem  `%MYCONF%\..\..` dir.
for %%i in (%MYCONF%..) do (
  set PORTABLE_HOME=%%~dpi
)


rem --- Check required dir structure -----------------------------------------

if not exist %PORTABLE_HOME%config (
  echo [init] Not found: %PORTABLE_HOME%config
  set /a MYERR=3
  exit /b %MYERR%
)

if not exist %PORTABLE_HOME%config\myconf (
  echo [init] Not found: %PORTABLE_HOME%config\myconf
  set /a MYERR=2
  exit /b %MYERR%
)

if not exist %PORTABLE_HOME%app (
  echo [init] Not found: %PORTABLE_HOME%app
  set /a MYERR=3
  exit /b %MYERR%
)

if not exist %PORTABLE_HOME%app\run (
  echo [init] Not found: %PORTABLE_HOME%app\run
  set /a MYERR=4
  exit /b %MYERR%
)
