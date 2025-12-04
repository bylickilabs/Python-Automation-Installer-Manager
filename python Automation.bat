@echo off
Color 0b
chcp 65001 >nul
setlocal EnableExtensions EnableDelayedExpansion
title Python Installer Manager 3.14.1


>nul 2>&1 net session
if NOT "%errorlevel%"=="0" (
    echo.
    echo ==========================================================
    echo   FEHLER: Dieses Installationsskript wurde ohne
    echo           Administratorrechte gestartet.
    echo ----------------------------------------------------------
    echo   So führen Sie das Skript korrekt aus:
    echo     1. Rechtsklick auf die Batch-Datei
    echo     2. "Als Administrator ausfuehren" auswählen
    echo ----------------------------------------------------------
    echo   Die Installation kann ohne Adminrechte nicht fortgesetzt
    echo   werden und wurde deshalb abgebrochen.
    echo ==========================================================
    echo.
    pause
    exit /b 1
)

echo.
echo ==========================================================
echo   ✔ Administratorrechte erkannt
echo   ✔ Installer wird fortgesetzt
echo ==========================================================
echo.


set "APP_TITLE=Python Installer Manager"
set "APP_VERSION=3.14.1"
set "APP_AUTHOR=Thorsten Bylicki"
set "APP_COMPANY=BYLICKI Software Solutions"
set "GITHUB_URL=https://github.com/bylickilabs"


set "PYTHON_VERSION=3.14.1"
set "PYTHON_INSTALLER=python-%PYTHON_VERSION%-amd64.exe"
set "PYTHON_URL=https://www.python.org/ftp/python/%PYTHON_VERSION%/%PYTHON_INSTALLER%"

set "DOWNLOAD_DIR=%USERPROFILE%\Downloads"
set "DESKTOP_INSTALLER=%USERPROFILE%\Desktop\%PYTHON_INSTALLER%"
set "LOG_DIR=%USERPROFILE%\Desktop\Python_Installer_Logs"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>&1
set "LOG_FILE=%LOG_DIR%\python_install_%PYTHON_VERSION%.log"


:select_language
Color 0b
cls
echo ===============================================
echo           Python Installer Manager
echo ===============================================
echo.
echo   Please choose language / Bitte Sprache waehlen
echo.
echo   1^) Deutsch
echo   2^) English
echo.
set /p "lang_choice=> "

if "%lang_choice%"=="1" (set "LANG=DE") else if "%lang_choice%"=="2" (set "LANG=EN") else goto select_language


if "%LANG%"=="DE" (
    set "TXT_MENU_TITLE=Python Installer Manager - Hauptmenue"
    set "TXT_MENU_1=Python 3.14.1 herunterladen"
    set "TXT_MENU_2=Python 3.14.1 installieren (vom Desktop)"
    set "TXT_MENU_3=Installierte Python-Version anzeigen"
    set "TXT_MENU_4=Log-Verzeichnis oeffnen"
    set "TXT_MENU_5=Informationen zur Anwendung"
    set "TXT_MENU_6=GitHub-Profil oeffnen"
    set "TXT_MENU_7=Beenden"

    set "TXT_STATUS_DOWNLOAD=Bereite Download des Python-Installers vor..."
    set "TXT_STATUS_INSTALL=Bereite Installation von Python 3.14.1 vor..."
    set "TXT_STATUS_SHOW_VER=Pruefe installierte Python-Version..."
    set "TXT_STATUS_LOG=Oeffne Log-Verzeichnis..."
    set "TXT_STATUS_INFO=Zeige Anwendungsinformationen..."
    set "TXT_STATUS_GITHUB=Oeffne GitHub-Profil..."

    set "TXT_DESKTOP_HINT=Installer wurde auf dem Desktop abgelegt."
    set "TXT_RESULT_OK=Vorgang erfolgreich abgeschlossen."
    set "TXT_RESULT_ERR=Ein Fehler ist aufgetreten. Details siehe Logdatei."
    set "TXT_PRESS_KEY=Druecke eine Taste, um fortzufahren..."

    set "TXT_NO_INSTALLER=Kein Installer auf dem Desktop gefunden. Bitte zuerst herunterladen."
    set "TXT_NO_PYTHON=Es konnte keine Python-Installation gefunden werden."
    set "TXT_LOCAL_VERSION=Installierte Python-Version:"
    set "TXT_PS_MISSING=PowerShell wurde nicht gefunden. Download ist nicht moeglich."

    set "TXT_INFO_HEADER=Anwendungsinformationen"
) else (
    set "TXT_MENU_TITLE=Python Installer Manager - Main Menu"
    set "TXT_MENU_1=Download Python 3.14.1"
    set "TXT_MENU_2=Install Python 3.14.1 (from Desktop)"
    set "TXT_MENU_3=Show installed Python version"
    set "TXT_MENU_4=Open log directory"
    set "TXT_MENU_5=Application information"
    set "TXT_MENU_6=Open GitHub profile"
    set "TXT_MENU_7=Exit"

    set "TXT_STATUS_DOWNLOAD=Preparing download of the Python installer..."
    set "TXT_STATUS_INSTALL=Preparing installation of Python 3.14.1..."
    set "TXT_STATUS_SHOW_VER=Checking installed Python version..."
    set "TXT_STATUS_LOG=Opening log directory..."
    set "TXT_STATUS_INFO=Showing application information..."
    set "TXT_STATUS_GITHUB=Opening GitHub profile..."

    set "TXT_DESKTOP_HINT=Installer has been copied to your Desktop."
    set "TXT_RESULT_OK=Operation completed successfully."
    set "TXT_RESULT_ERR=An error occurred. Check log file for details."
    set "TXT_PRESS_KEY=Press any key to continue..."

    set "TXT_NO_INSTALLER=No installer found on Desktop. Please download first."
    set "TXT_NO_PYTHON=No Python installation was detected."
    set "TXT_LOCAL_VERSION=Installed Python version:"
    set "TXT_PS_MISSING=PowerShell not found. Download is not possible."

    set "TXT_INFO_HEADER=Application Information"
)


:main_menu
Color 0b
cls
::call :banner
echo ===============================================
echo   %TXT_MENU_TITLE%
echo ===============================================
echo.
echo   1 ^) %TXT_MENU_1%
echo   2 ^) %TXT_MENU_2%
echo   3 ^) %TXT_MENU_3%
echo   4 ^) %TXT_MENU_4%
echo   5 ^) %TXT_MENU_5%
echo   6 ^) %TXT_MENU_6%
echo   7 ^) %TXT_MENU_7%
echo.
set /p "choice=> "

if "%choice%"=="1" goto download_python
if "%choice%"=="2" goto install_python
if "%choice%"=="3" goto show_installed_python
if "%choice%"=="4" goto open_log_dir
if "%choice%"=="5" goto show_info
if "%choice%"=="6" goto open_github
if "%choice%"=="7" goto end_app
goto main_menu


:download_python
Color 0b
call :phase_animation "%TXT_STATUS_DOWNLOAD%"
cls
echo %TXT_STATUS_DOWNLOAD%
echo %DATE% %TIME%: Starting download of Python %PYTHON_VERSION% >> "%LOG_FILE%"

where powershell >nul 2>&1
if errorlevel 1 (
    echo %TXT_PS_MISSING%
    echo %DATE% %TIME%: PowerShell not found. Download aborted. >> "%LOG_FILE%"
    echo.
    echo %TXT_PRESS_KEY%
    pause >nul
    goto main_menu
)

powershell -NoLogo -NoProfile -Command ^
 "try { Invoke-WebRequest '%PYTHON_URL%' -OutFile '%DOWNLOAD_DIR%\%PYTHON_INSTALLER%' -UseBasicParsing } catch { exit 1 }" ^
 >> "%LOG_FILE%" 2>&1

if errorlevel 1 (
    echo %TXT_RESULT_ERR%
    echo %DATE% %TIME%: Download failed. >> "%LOG_FILE%"
    echo.
    echo %TXT_PRESS_KEY%
    pause >nul
    goto main_menu
)

copy /Y "%DOWNLOAD_DIR%\%PYTHON_INSTALLER%" "%DESKTOP_INSTALLER%" >nul 2>&1
echo %DATE% %TIME%: Installer copied to Desktop: %DESKTOP_INSTALLER% >> "%LOG_FILE%"

echo.
echo %TXT_RESULT_OK%
echo %TXT_DESKTOP_HINT%
echo.
echo %TXT_PRESS_KEY%
pause >nul
goto main_menu


:install_python
Color 0b
call :phase_animation "%TXT_STATUS_INSTALL%"
cls
echo %TXT_STATUS_INSTALL%
echo %DATE% %TIME%: Starting installation from Desktop: %DESKTOP_INSTALLER% >> "%LOG_FILE%"

if not exist "%DESKTOP_INSTALLER%" (
    echo %TXT_NO_INSTALLER%
    echo %DATE% %TIME%: Desktop installer not found. >> "%LOG_FILE%"
    echo.
    echo %TXT_PRESS_KEY%
    pause >nul
    goto main_menu
)

"%DESKTOP_INSTALLER%" /passive InstallAllUsers=1 PrependPath=1 Include_test=0 >> "%LOG_FILE%" 2>&1

if errorlevel 1 (
    echo %TXT_RESULT_ERR%
    echo %DATE% %TIME%: Installation failed. >> "%LOG_FILE%"
) else (
    echo %TXT_RESULT_OK%
    echo %DATE% %TIME%: Installation completed successfully. >> "%LOG_FILE%"
)

echo.
echo %TXT_PRESS_KEY%
pause >nul
goto main_menu


:show_installed_python
Color 0b
call :phase_animation "%TXT_STATUS_SHOW_VER%"
cls
echo %TXT_STATUS_SHOW_VER%
echo %DATE% %TIME%: Checking local Python installation... >> "%LOG_FILE%"

set "LOCAL_VERSION="
for /f "tokens=2" %%p in ('py -V 2^>nul') do set "LOCAL_VERSION=%%p"

if not defined LOCAL_VERSION (
    echo %TXT_NO_PYTHON%
    echo %DATE% %TIME%: No Python installation detected. >> "%LOG_FILE%"
) else (
    echo %TXT_LOCAL_VERSION% %LOCAL_VERSION%
    echo %DATE% %TIME%: Local Python version: %LOCAL_VERSION% >> "%LOG_FILE%"
)

echo.
echo %TXT_PRESS_KEY%
pause >nul
goto main_menu


:open_log_dir
Color 0b
call :phase_animation "%TXT_STATUS_LOG%"
cls
echo %TXT_STATUS_LOG%
echo %DATE% %TIME%: Opening log directory. >> "%LOG_FILE%"
start "" "%LOG_DIR%"
echo.
echo %TXT_PRESS_KEY%
pause >nul
goto main_menu


:show_info
color 0b
call :phase_animation "%TXT_STATUS_INFO%"
cls
echo ===============================================
echo   %TXT_INFO_HEADER%
echo ===============================================
echo.
echo   %APP_TITLE%
echo   Version: %APP_VERSION%
echo   Author : %APP_AUTHOR%
echo   Firma  : %APP_COMPANY%
echo.
echo   Python Target Version : %PYTHON_VERSION%
echo.
echo   Download URL:
echo   %PYTHON_URL%
echo.
echo   Installer (Desktop):
echo   %DESKTOP_INSTALLER%
echo.
echo   Log Directory:
echo   %LOG_DIR%
echo.
echo ===============================================
echo.
echo %TXT_PRESS_KEY%
pause >nul
goto main_menu


:open_github
Color 0b
call :phase_animation "%TXT_STATUS_GITHUB%"
cls
echo %TXT_STATUS_GITHUB%
echo %DATE% %TIME%: Opening GitHub profile %GITHUB_URL% >> "%LOG_FILE%"
start "" "%GITHUB_URL%"
echo.
echo %TXT_PRESS_KEY%
pause >nul
goto main_menu


:phase_animation
set "PHASE_MSG=%~1"
set "bar="
for /L %%i in (1,1,20) do (
    set "bar=!bar!#"
    cls
    echo.
    echo  %PHASE_MSG%
    echo.
    echo  [!bar!**********************]
    ping 127.0.0.1 -n 1 -w 120 >nul
)
goto :EOF


:banner
echo ===============================================
echo   %APP_TITLE% – Python %PYTHON_VERSION%
echo ===============================================
goto :EOF


:end_app
echo %DATE% %TIME%: Application terminated by user. >> "%LOG_FILE%"
endlocal
exit /b