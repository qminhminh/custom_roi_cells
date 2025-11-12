@echo off
chcp 65001 >nul
echo.
echo ╔════════════════════════════════════════════════╗
echo ║   CHẠY APP CUSTOM ROI CAMERA CELLS            ║
echo ╚════════════════════════════════════════════════╝
echo.
echo Đang kiểm tra Flutter...
where flutter >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ LỖI: Flutter chưa được cài đặt hoặc chưa thêm vào PATH
    echo.
    echo Hãy:
    echo 1. Cài đặt Flutter từ https://flutter.dev
    echo 2. Hoặc mở Android Studio và chạy từ đó
    echo.
    pause
    exit /b 1
)

echo ✅ Flutter đã được cài đặt
echo.

cd /d %~dp0

echo 📦 Đang cài đặt dependencies...
call flutter pub get
if %errorlevel% neq 0 (
    echo ❌ LỖI: Không thể cài đặt dependencies
    pause
    exit /b 1
)

echo.
echo 📱 Đang kiểm tra devices...
call flutter devices
echo.

echo 🚀 Đang chạy app...
echo.
echo 💡 LƯU Ý:
echo    - Nếu chưa có device, hãy tạo emulator trong Android Studio
echo    - Hoặc kết nối điện thoại Android và bật USB Debugging
echo.
echo Đang khởi động...
call flutter run

if %errorlevel% neq 0 (
    echo.
    echo ❌ LỖI: Không thể chạy app
    echo.
    echo Hãy thử:
    echo 1. Mở Android Studio
    echo 2. File → Open → Chọn thư mục 'example'
    echo 3. Nhấn nút Run (▶)
    echo.
)

pause

