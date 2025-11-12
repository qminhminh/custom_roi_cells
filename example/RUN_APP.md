# Hướng dẫn chạy Example App

## Cách 1: Chạy trong Android Studio (Khuyên dùng)

1. **Mở project trong Android Studio:**
   - Mở Android Studio
   - File → Open → Chọn thư mục `example`
   - Hoặc mở thư mục `custom_roi_camera_cells` và chọn thư mục `example` trong project

2. **Chạy app:**
   - Chọn device/emulator từ danh sách devices
   - Nhấn nút Run (▶) hoặc nhấn `Shift + F10`
   - App sẽ được build và chạy trên device/emulator

3. **Xem giao diện:**
   - App sẽ hiển thị grid cells với khả năng selection
   - Tap vào các cells để chọn/bỏ chọn
   - Drag để chọn nhiều cells
   - Sử dụng nút Save, Delete, Clear để quản lý selection

## Cách 2: Chạy từ Terminal/Command Prompt

### Bước 1: Cài đặt dependencies
```bash
cd example
flutter pub get
```

### Bước 2: Kiểm tra devices
```bash
flutter devices
```

### Bước 3: Chạy app
```bash
flutter run
```

Hoặc chạy trên device cụ thể:
```bash
flutter run -d <device-id>
```

## Cách 3: Chạy trên Web (nếu hỗ trợ)

```bash
cd example
flutter run -d chrome
```

## Tính năng trong Example App

1. **Nhập thông số:** Điều chỉnh kích thước màn hình và số lượng cells
2. **Selection mode:** 
   - Tap để chọn/bỏ chọn một cell
   - Drag để chọn nhiều cells
   - Cells được chọn sẽ hiển thị màu đỏ
3. **Nút điều khiển:**
   - **Save:** Lưu danh sách index đã chọn
   - **Delete:** Xóa cells đã chọn
   - **Clear:** Xóa tất cả selection
4. **Hiển thị kết quả:** Hiển thị mảng index đã chọn dưới dạng [0,1,2,3,...]

## Lưu ý

- Đảm bảo đã cài đặt Flutter SDK
- Đảm bảo đã kết nối device hoặc khởi động emulator
- Nếu gặp lỗi, thử chạy `flutter clean` và `flutter pub get` lại

