# 🚀 CHẠY APP NHANH - XEM GIAO DIỆN

## ⚡ Cách NHANH NHẤT (3 bước)

### Bước 1: Mở Android Studio
- Mở Android Studio
- **File → Open** → Chọn thư mục `example`

### Bước 2: Chọn Device
- Ở thanh trên cùng, chọn device (emulator hoặc điện thoại)
- Nếu chưa có, tạo emulator: **Tools → Device Manager → Create Device**

### Bước 3: Chạy
- Nhấn nút **▶ Run** (màu xanh) hoặc nhấn **Shift + F10**
- Đợi app build và chạy (1-2 phút lần đầu)

---

## 📱 GIAO DIỆN SẼ HIỂN THỊ:

```
┌─────────────────────────────────────────┐
│  Custom ROI Camera Cells                │
├─────────────────────────────────────────┤
│                                         │
│  ┌───────────────────────────────────┐ │
│  │ 📱 Custom ROI Camera Cells        │ │
│  │ • Tap để chọn/bỏ chọn một cell   │ │
│  │ • Drag để chọn nhiều cells        │ │
│  │ • Cells được chọn sẽ hiển thị màu │ │
│  │   đỏ                              │ │
│  └───────────────────────────────────┘ │
│                                         │
│  Grid Cells (15x15):                   │
│  ┌─────────────────────────────────┐   │
│  │ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ │   │
│  │ ⬜ 🔴 🔴 🔴 ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ │   │
│  │ ⬜ 🔴 🔴 🔴 ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ │   │
│  │ ⬜ 🔴 🔴 🔴 ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ │   │
│  │ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ │   │
│  │ ... (15x15 grid)                  │   │
│  └─────────────────────────────────┘   │
│                                         │
│  [Save] [Delete] [Clear]               │
│                                         │
│  ✅ Đã chọn 9 cells:                   │
│  Danh sách: 16, 17, 18, 31, 32, ...   │
│  Mảng: [16,17,18,31,32,33,46,47,48]   │
│                                         │
└─────────────────────────────────────────┘
```

---

## ✨ CÁCH SỬ DỤNG:

1. **Tap vào cell**: Chọn/bỏ chọn (màu đỏ = đã chọn)
2. **Drag chuột/finger**: Chọn nhiều cells cùng lúc
3. **Nút Save**: Lưu danh sách index đã chọn
4. **Nút Delete**: Xóa cells đã chọn
5. **Nút Clear**: Xóa tất cả selection

---

## 🎯 KIỂM TRA CHỨC NĂNG:

### ✅ Test 1: Tap để chọn
- Tap vào một cell bất kỳ
- Cell sẽ chuyển sang màu đỏ
- Tap lại để bỏ chọn

### ✅ Test 2: Drag để chọn
- Nhấn và giữ chuột/finger trên một cell
- Kéo sang các cells khác
- Tất cả cells trong phạm vi kéo sẽ được chọn

### ✅ Test 3: Lưu selection
- Chọn một số cells
- Nhấn nút **Save**
- Xem mảng index hiển thị bên dưới: `[0,1,2,3,...]`

### ✅ Test 4: Xóa selection
- Chọn một số cells
- Nhấn nút **Delete** hoặc **Clear**
- Cells sẽ được bỏ chọn

---

## 🐛 NẾU GẶP LỖI:

### Lỗi: "Flutter not found"
```bash
# Kiểm tra Flutter đã cài chưa
flutter --version

# Nếu chưa, cài Flutter từ:
# https://flutter.dev/docs/get-started/install
```

### Lỗi: "No devices found"
1. Mở Android Studio
2. **Tools → Device Manager**
3. Tạo emulator mới hoặc kết nối điện thoại

### Lỗi: "Build failed"
```bash
cd example
flutter clean
flutter pub get
flutter run
```

---

## 📸 MÔ TẢ GIAO DIỆN CHI TIẾT:

### 1. **Header (Màu xanh nhạt)**
- Tiêu đề: "📱 Custom ROI Camera Cells"
- Hướng dẫn sử dụng 3 dòng

### 2. **Grid Cells (Màu trắng với border xanh)**
- Lưới 15 hàng x 15 cột
- Tổng cộng 225 cells
- Cells chưa chọn: màu trắng
- Cells đã chọn: màu đỏ (70% opacity)
- Border: màu xanh nhạt

### 3. **Nút điều khiển**
- **Save** (màu xanh): Lưu selection
- **Delete** (màu đen): Xóa selection
- **Clear** (màu xám): Xóa tất cả

### 4. **Kết quả (Màu xanh nhạt)**
- Số lượng cells đã chọn
- Danh sách index
- Mảng JSON: `[0,1,2,3,...]`

---

## 🎬 VIDEO HƯỚNG DẪN (Mô tả):

1. Mở app → Thấy grid 15x15
2. Tap vào cell đầu tiên → Cell chuyển đỏ
3. Tap vào cell thứ 2, 3, 4 → Nhiều cells đỏ
4. Drag từ cell 10 đến cell 20 → Chọn range
5. Nhấn Save → Thấy mảng `[10,11,12,...,20]`
6. Nhấn Clear → Tất cả cells trở về trắng

---

## 💡 TIPS:

- **Zoom**: Pinch để zoom (trên mobile)
- **Scroll**: Kéo để scroll (nếu grid lớn)
- **Multiple selection**: Có thể tap nhiều lần để chọn nhiều cells riêng lẻ
- **Range selection**: Drag để chọn một vùng

---

## ✅ CHECKLIST KIỂM TRA:

- [ ] App chạy được
- [ ] Grid hiển thị đúng 15x15
- [ ] Tap chọn cell được
- [ ] Drag chọn nhiều cells được
- [ ] Cells được chọn hiển thị màu đỏ
- [ ] Nút Save hoạt động
- [ ] Nút Delete hoạt động
- [ ] Nút Clear hoạt động
- [ ] Mảng index hiển thị đúng

---

**Chúc bạn thành công! 🎉**

