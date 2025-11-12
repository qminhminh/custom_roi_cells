@echo off
echo ========================================
echo Running Custom ROI Camera Cells Example
echo ========================================
echo.

cd /d %~dp0

echo Step 1: Installing dependencies...
call flutter pub get
if errorlevel 1 (
    echo Error: Failed to install dependencies
    pause
    exit /b 1
)

echo.
echo Step 2: Checking available devices...
call flutter devices

echo.
echo Step 3: Running app...
call flutter run

pause

