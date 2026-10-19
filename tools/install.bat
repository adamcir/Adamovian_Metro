@echo off
setlocal
set "SOURCE=%~dp0..\addon\adamovian_metro"
set "GMOD=%~1"
if not defined GMOD set "GMOD=%ProgramFiles(x86)%\Steam\steamapps\common\GarrysMod\garrysmod"
if not exist "%SOURCE%\lua\" (echo Addon source not found: "%SOURCE%" & exit /b 1)
if not exist "%GMOD%\" (echo Garrys Mod folder not found: "%GMOD%" & exit /b 1)
set "DEST=%GMOD%\addons\adamovian_metro"
if not exist "%DEST%\" mkdir "%DEST%"
xcopy "%SOURCE%\*" "%DEST%\" /E /I /Y /Q >nul
if errorlevel 1 (echo Installation failed. & exit /b 1)
echo Adamovian Metro installed to: "%DEST%"
endlocal
