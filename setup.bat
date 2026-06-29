@echo off
REM ===================================================================
REM  ONE-TIME SETUP (Windows). Double-click this once.
REM  Creates an isolated Python environment and installs the libraries.
REM ===================================================================
cd /d "%~dp0"

echo.
echo Checking Python...
python --version
if errorlevel 1 (
    echo.
    echo  Python was not found. Install it first from https://www.python.org/downloads/
    echo  IMPORTANT: on the first install screen, tick "Add python.exe to PATH".
    echo.
    pause
    exit /b 1
)

echo.
echo Creating virtual environment (.venv)...
python -m venv .venv

echo.
echo Installing libraries from the bundled 'vendor' folder (no internet needed)...
call .venv\Scripts\activate.bat
python -m pip install --no-index --find-links vendor -r requirements.txt
if errorlevel 1 (
    echo.
    echo  Offline install did not complete - trying the internet as a fallback...
    echo  ^(This usually means a different Python version. Recommended: Python 3.12.^)
    python -m pip install -r requirements.txt
)

echo.
echo ===================================================================
echo  Setup complete. You can now double-click  run_watcher.bat
echo ===================================================================
pause
