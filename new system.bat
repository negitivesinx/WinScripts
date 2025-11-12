@echo off
setlocal

:: =============================================================================
:: Check for Administrator Privileges
:: =============================================================================
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else (
    goto gotAdmin
)

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs"
    pushd "%CD%"
    CD /D "%~dp0"

:: =============================================================================
:: Configuration Questions
:: =============================================================================
echo --- System Configuration ---
:AskLaptop
set /p "PC=Is this a laptop? (Y/N): "
if /I not "%PC%"=="Y" if /I not "%PC%"=="N" (
    echo Please enter Y or N.
    goto AskLaptop
)

:AskDriveD
set /p "DriveD=Does this system have a D: drive? (Y/N): "
if /I not "%DriveD%"=="Y" if /I not "%DriveD%"=="N" (
    echo Please enter Y or N.
    goto AskDriveD
)

:AskRAM
set /p "HighRAM=Do you have more than 9GB of RAM? (Y/N): "
if /I not "%HighRAM%"=="Y" if /I not "%HighRAM%"=="N" (
    echo Please enter Y or N.
    goto AskRAM
)
echo(

:: =============================================================================
:: System Tweaks
:: =============================================================================
echo --- Applying System Tweaks ---
REM Disable Hibernation only if it's NOT a laptop
if /I "%PC%"=="N" (
    echo Disabling hibernation (requires restart to take full effect)...
    powercfg -h off
    if %errorlevel% neq 0 ( echo Failed to disable hibernation. ) else ( echo Hibernation disabled. )
) else (
    echo Skipping hibernation disable (Laptop detected).
)

REM --- Optional Page File Configuration ---
REM Note: Manually setting page files is often unnecessary. Windows manages it well.
REM This section is kept for reference but remains commented out.
REM Consider uncommenting ONLY if you have a specific need and understand the implications.
REM
REM if /I "%DriveD%"=="Y" if /I "%HighRAM%"=="Y" (
REM     echo Checking for D: drive...
REM     if exist D:\ (
REM         echo Attempting to set page file on D: to 10GB (Initial=10000MB, Max=10000MB)...
REM         wmic pagefileset where name="D:\\pagefile.sys" set InitialSize=10000,MaximumSize=10000
REM         if %errorlevel% neq 0 (
REM             echo Failed to set page file on D:. It might already exist or another issue occurred.
REM             echo You may need to manually configure it via System Properties > Advanced > Performance Settings.
REM         ) else (
REM             echo Page file setting command executed. A restart is required for changes to apply.
REM         )
REM     ) else (
REM         echo D: drive not found, cannot set page file there.
REM     )
REM ) else (
REM    echo Skipping manual page file configuration based on user input or drive availability.
REM )
echo(

:: =============================================================================
:: PowerShell Setup
:: =============================================================================
echo --- Configuring PowerShell ---
echo Setting Execution Policy to RemoteSigned for Current Process...
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy RemoteSigned -Scope Process -Force"
if %errorlevel% neq 0 ( echo Failed to set PowerShell execution policy for this process. ) else ( echo Execution policy set for this process. )

echo Installing PSWindowsUpdate module (requires internet connection)...
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Install-Module -Name PSWindowsUpdate -Force -AcceptLicense -Scope CurrentUser"
if %errorlevel% neq 0 ( echo Failed to install PSWindowsUpdate module. Check internet connection and PowerShell Gallery access. ) else ( echo PSWindowsUpdate module installed for current user. )
echo(

:: =============================================================================
:: Install Basic Desktop Apps via Winget
:: =============================================================================
echo --- Installing Basic Desktop Apps ---
echo Installing Notepad++...
winget install --id Notepad++.Notepad++ --accept-package-agreements --accept-source-agreements --silent
if %errorlevel% neq 0 ( echo Failed to install Notepad++. ) else ( echo Notepad++ installed. )

echo Installing 7-Zip...
winget install --id 7zip.7zip --accept-package-agreements --accept-source-agreements --silent
if %errorlevel% neq 0 ( echo Failed to install 7-Zip. ) else ( echo 7-Zip installed. )

echo Installing Twitch...
winget install --id Twitch.Twitch --accept-package-agreements --accept-source-agreements --silent
if %errorlevel% neq 0 ( echo Failed to install Twitch. ) else ( echo Twitch installed. )

echo Installing Core Temp...
winget install --id ALCPU.CoreTemp --accept-package-agreements --accept-source-agreements --silent
if %errorlevel% neq 0 ( echo Failed to install Core Temp. ) else ( echo Core Temp installed. )

echo Installing VNC Viewer...
winget install --id RealVNC.VNCViewer --accept-package-agreements --accept-source-agreements --silent
if %errorlevel% neq 0 ( echo Failed to install VNC Viewer. ) else ( echo VNC Viewer installed. )

echo Installing VNC Server...
winget install --id RealVNC.VNCServer --accept-package-agreements --accept-source-agreements --silent
if %errorlevel% neq 0 ( echo Failed to install VNC Server. ) else ( echo VNC Server installed. )
echo(

:: =============================================================================
:: Install Gaming Apps via Winget (Optional)
:: =============================================================================
:AskGamer
set /p "Gamer=Is this a gaming system? (Y/N): "
if /I not "%Gamer%"=="Y" if /I not "%Gamer%"=="N" (
    echo Please enter Y or N.
    goto AskGamer
)

if /I "%Gamer%"=="N" (
    echo Skipping gaming app installations.
    goto EndScript
)

echo --- Installing Gaming Apps ---
echo Installing Valve Steam...
winget install --id Valve.Steam --accept-package-agreements --accept-source-agreements --silent
if %errorlevel% neq 0 ( echo Failed to install Steam. ) else ( echo Steam installed. )

echo Installing Epic Games Launcher...
winget install --id EpicGames.EpicGamesLauncher --accept-package-agreements --accept-source-agreements --silent
if %errorlevel% neq 0 ( echo Failed to install Epic Games Launcher. ) else ( echo Epic Games Launcher installed. )

echo Installing GOG Galaxy...
winget install --id GOG.Galaxy --accept-package-agreements --accept-source-agreements --silent
if %errorlevel% neq 0 ( echo Failed to install GOG Galaxy. ) else ( echo GOG Galaxy installed. )

echo Installing Ubisoft Connect...
winget install --id Ubisoft.Connect --accept-package-agreements --accept-source-agreements --silent
if %errorlevel% neq 0 ( echo Failed to install Ubisoft Connect. ) else ( echo Ubisoft Connect installed. )

echo Installing Amazon Games...
winget install --id Amazon.Games --accept-package-agreements --accept-source-agreements --silent
if %errorlevel% neq 0 ( echo Failed to install Amazon Games. ) else ( echo Amazon Games installed. )
echo(

:: =============================================================================
:: Finish
:: =============================================================================
:EndScript
echo --- Script Finished ---
echo Some changes like hibernation or page file settings may require a restart.
echo Winget installations might run in the background.
popd
endlocal
pause
exit /B

