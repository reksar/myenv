@echo off

rem  --------------------------------------------------------------------------
rem  Portable myenv dir three:
rem
rem  MYHOME  <-- portable root
rem  |- app
rem     |- cfg
rem     |  |- myenv
rem     |     |- windows
rem     |        |- scripts  <-- current dir
rem     |           |- install
rem     |- run  <-- portable software
rem        |- cmake
rem        |- git
rem        |- nvim
rem        |- python
rem        |- vim
rem  --------------------------------------------------------------------------


for %%i in ("%~dp0..\..\..\..\..") do (
  set "MYHOME=%%~fi"
)
set "MYENV=%MYHOME%\app\cfg\myenv"


rem  --- Set PATH to portable software ----------------------------------------

set "MYENV_RUN=%MYHOME%\app\run"


rem  --- Python ---
if exist "%MYENV_RUN%\python\python.exe" (
  set "PATH=%MYENV_RUN%\python;%MYENV_RUN%\python\Scripts;%PATH%"
)

rem  --- Git ---
if exist "%MYENV_RUN%\git\bin\git.exe" (
  set "PATH=%MYENV_RUN%\git\bin;%PATH%"
) else (
  if exist "%MYENV_RUN%\git\cmd\git.exe" (
    set "PATH=%MYENV_RUN%\git\cmd;%PATH%"
  )
)

rem  --- Git utils ---
for /f %%i in ('where git 2^>NUL') do (
  for %%j in (%%~dpi..) do (
    if exist "%%~fj\usr\bin" (
      set "PATH=%%~fj\usr\bin;%PATH%"
    )
  )
)

rem  --- Neovim ---
if exist "%MYENV_RUN%\nvim\bin\nvim.exe" (
  set "PATH=%MYENV_RUN%\nvim\bin;%PATH%"
)

rem  --- Vim ---
for /d %%i in ("%MYENV_RUN%\vim\vim*") do (
  if exist "%%i\gvim.exe" (
    set "PATH=%%i;%PATH%"
  ) else (
    if exist "%%i\vim.exe" (
      set "PATH=%%i;%PATH%"
    )
  )
)

rem  --- CMake ---
if exist "%MYENV_RUN%\cmake\bin\cmake.exe" (
  set "PATH=%MYENV_RUN%\cmake\bin;%PATH%"
)

rem  --- VC ---
if exist "%MYENV_RUN%\vc\vcvars-x64-x64.bat" (
  call "%MYENV_RUN%\vc\vcvars-x64-x64.bat"
)

rem  --- Ripgrep ---
if exist "%MYENV_RUN%\ripgrep\rg.exe" (
  set "PATH=%MYENV_RUN%\ripgrep;%PATH%"
)


set MYENV_RUN=


rem  --- Set PATH to Windows utility scripts ----------------------------------

set "PATH=%~dp0;%PATH%"

rem  Consider the trailing backslash!
set "MYENV_SCRIPTS=%MYENV%\windows\scripts\"

rem  Validate.
if not "%MYENV_SCRIPTS%" == "%~dp0" (
  echo [WARN][MYENV] "%MYENV_SCRIPTS%" != "%~dp0"
)

set MYENV_SCRIPTS=


rem  --- CD if passed ---------------------------------------------------------
if not "" == "%*" cd /d "%*"
