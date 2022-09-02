@echo off

set XDG_CONFIG_HOME=%~dp0..\share

if not "%~1"=="" (
  set d=/d "%~1"
)

start %d% %~dp0nvim-qt.exe
