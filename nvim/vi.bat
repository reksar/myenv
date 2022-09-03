@echo off
set XDG_CONFIG_HOME=%~dp0..\share
if not "%~1"=="" (cd /d "%~1")
%~dp0nvim.exe %*
