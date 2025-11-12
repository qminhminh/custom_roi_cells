# 🚀 Hướng dẫn chạy Example App

## Cách 1: Chạy trong Android Studio (Khuyên dùng - Dễ nhất) ⭐

### Bước 1: Mở project
1. Mở **Android Studio**
2. Chọn **File → Open**
3. Chọn thư mục **`example`** trong project này
   - Đường dẫn: `custom_roi_camera_cells/example`

### Bước 2: Chờ Android Studio sync
- Android Studio sẽ tự động sync dependencies
- Đợi cho đến khi sync xong (thường mất 1-2 phút)

### Bước 3: Chọn device
- Chọn device/emulator từ dropdown ở trên cùng
- Hoặc kết nối điện thoại Android và bật USB Debugging
- Hoặc tạo một Android Emulator mới

### Bước 4: Chạy app
- Nhấn nút **Run** (▶) màu xanh ở trên cùng
- Hoặc nhấn **Shift + F10**
- App sẽ được build và chạy tự động

### Bước 5: Xem giao diện
- App sẽ hiển thị grid cells 15x15
- **Tap** vào các cells để chọn (màu đỏ)
- **Drag** để chọn nhiều cells
- Sử dụng nút **Save**, **Delete**, **Clear** để quản lý

---

## Cách 2: Chạy từ Terminal (Nếu đã cài Flutter)

### Windows (PowerShell hoặc CMD):
```powershell
cd example
flutter pub get
flutter run
```

### Mac/Linux:
```bash
cd example
flutter pub get
flutter run
```

---

## Cách 3: Chạy trên Web (Nếu hỗ trợ)

```bash
cd example
flutter run -d chrome
```

---

## 📱 Giao diện sẽ hiển thị:

1. **Header**: Hướng dẫn sử dụng
2. **Grid Cells**: Lưới 15x15 cells với khả năng selection
3. **Nút điều khiển**: Save, Delete, Clear
4. **Kết quả**: Hiển thị danh sách index đã chọn dưới dạng mảng `[0,1,2,3,...]`

## ✨ Tính năng:

- ✅ Tap để chọn/bỏ chọn một cell
- ✅ Drag để chọn nhiều cells
- ✅ Cells được chọn hiển thị màu đỏ
- ✅ Lưu selection dưới dạng mảng index
- ✅ Xóa selection
- ✅ Hiển thị kết quả dưới dạng JSON array

## 🔧 Yêu cầu:

- Android Studio (hoặc VS Code với Flutter extension)
- Flutter SDK đã được cài đặt
- Android Emulator hoặc thiết bị Android thật
- Đã kết nối device/emulator

## ❓ Gặp vấn đề?

1. **Lỗi "Flutter not found"**:
   - Đảm bảo đã cài Flutter SDK
   - Thêm Flutter vào PATH

2. **Lỗi "No devices found"**:
   - Khởi động Android Emulator
   - Hoặc kết nối điện thoại và bật USB Debugging

3. **Lỗi build**:
   - Chạy `flutter clean`
   - Chạy `flutter pub get` lại
   - Xóa thư mục `.dart_tool` và `build`

---

## 📸 Ảnh chụp màn hình:

Sau khi chạy app, bạn sẽ thấy:
- Grid cells với border màu xanh
- Cells được chọn sẽ có màu đỏ
- Nút Save, Delete, Clear ở dưới
- Hiển thị mảng index đã chọn

**Chúc bạn thành công! 🎉**

