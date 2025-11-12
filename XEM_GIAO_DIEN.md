# 👀 XEM GIAO DIỆN VÀ KIỂM TRA CHỨC NĂNG

## 🎯 MỤC TIÊU
Xem giao diện app và test tất cả chức năng đã code

---

## 📋 CHECKLIST CHỨC NĂNG

### 1. ✅ Giao diện cơ bản
- [ ] App mở được
- [ ] Header hiển thị đúng
- [ ] Grid cells hiển thị 15x15
- [ ] Nút Save, Delete, Clear hiển thị

### 2. ✅ Chức năng Selection
- [ ] Tap vào cell → Cell chuyển màu đỏ
- [ ] Tap lại → Cell bỏ chọn (trở về trắng)
- [ ] Drag từ cell này sang cell khác → Chọn range
- [ ] Drag theo đường chéo → Chọn hình chữ nhật

### 3. ✅ Hiển thị kết quả
- [ ] Chọn cells → Hiển thị số lượng
- [ ] Chọn cells → Hiển thị danh sách index
- [ ] Chọn cells → Hiển thị mảng JSON: `[0,1,2,3,...]`

### 4. ✅ Nút điều khiển
- [ ] Nhấn Save → Lưu selection và hiển thị mảng
- [ ] Nhấn Delete → Xóa cells đã chọn
- [ ] Nhấn Clear → Xóa tất cả selection

---

## 🎨 MÔ TẢ GIAO DIỆN

### Màu sắc:
- **Header**: Màu xanh nhạt (#E3F2FD)
- **Grid background**: Màu trắng
- **Cells chưa chọn**: Màu trắng
- **Cells đã chọn**: Màu đỏ (70% opacity)
- **Border cells**: Màu xanh nhạt (#90CAF9)
- **Nút Save**: Màu xanh (#2196F3)
- **Nút Delete**: Màu đen (#424242)
- **Nút Clear**: Màu xám (#9E9E9E)

### Kích thước:
- **Grid**: 600px x 400px
- **Cells**: ~40px x ~27px (tự động tính)
- **Border**: 0.5px

---

## 🧪 TEST CASES

### Test 1: Chọn một cell
```
1. Tap vào cell ở vị trí (0,0) - index 0
2. Kỳ vọng: Cell chuyển màu đỏ
3. Kiểm tra: selectedIndices = [0]
```

### Test 2: Chọn nhiều cells riêng lẻ
```
1. Tap vào cell 0
2. Tap vào cell 5
3. Tap vào cell 10
4. Kỳ vọng: 3 cells đỏ
5. Kiểm tra: selectedIndices = [0, 5, 10]
```

### Test 3: Drag để chọn range
```
1. Nhấn và giữ cell 20
2. Kéo đến cell 25
3. Kỳ vọng: Cells 20-25 đều đỏ
4. Kiểm tra: selectedIndices = [20, 21, 22, 23, 24, 25]
```

### Test 4: Chọn hình chữ nhật
```
1. Nhấn và giữ cell 30 (hàng 2, cột 0)
2. Kéo đến cell 45 (hàng 3, cột 0)
3. Kỳ vọng: Chọn cả hàng 2 và hàng 3
4. Kiểm tra: selectedIndices chứa cells từ 30-44
```

### Test 5: Save selection
```
1. Chọn một số cells
2. Nhấn nút Save
3. Kỳ vọng: Hiển thị SnackBar "✅ Đã lưu X cells"
4. Kiểm tra: Mảng index hiển thị đúng
```

### Test 6: Delete selection
```
1. Chọn một số cells
2. Nhấn nút Delete
3. Kỳ vọng: Cells được bỏ chọn, hiển thị SnackBar
4. Kiểm tra: selectedIndices = []
```

### Test 7: Clear selection
```
1. Chọn nhiều cells
2. Nhấn nút Clear
3. Kỳ vọng: Tất cả cells bỏ chọn
4. Kiểm tra: selectedIndices = []
```

---

## 📸 SCREENSHOTS MÔ TẢ

### Màn hình chính:
```
┌──────────────────────────────────────┐
│  Custom ROI Camera Cells        [×]  │
├──────────────────────────────────────┤
│                                      │
│  ┌────────────────────────────────┐ │
│  │ 📱 Custom ROI Camera Cells     │ │
│  │ • Tap để chọn/bỏ chọn một cell│ │
│  │ • Drag để chọn nhiều cells     │ │
│  │ • Cells được chọn sẽ hiển thị  │ │
│  │   màu đỏ                       │ │
│  └────────────────────────────────┘ │
│                                      │
│  Grid Cells (15x15):                │
│  ┌──────────────────────────────┐   │
│  │ ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ │   │
│  │ ⬜🔴🔴🔴⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ │   │
│  │ ⬜🔴🔴🔴⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ │   │
│  │ ⬜🔴🔴🔴⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ │   │
│  │ ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ │   │
│  │ ... (15 hàng x 15 cột)        │   │
│  └──────────────────────────────┘   │
│                                      │
│  [Save]  [Delete]  [Clear]          │
│                                      │
│  ✅ Đã chọn 9 cells:                │
│  Danh sách: 16, 17, 18, 31, 32, ... │
│  Mảng: [16,17,18,31,32,33,46,47,48] │
│                                      │
└──────────────────────────────────────┘
```

### Khi chọn cells:
- Cells được chọn: Màu đỏ (🔴)
- Cells chưa chọn: Màu trắng (⬜)
- Border: Màu xanh nhạt

---

## 🚀 CÁCH CHẠY NHANH

### Option 1: Android Studio (Khuyên dùng)
1. Mở Android Studio
2. File → Open → `example`
3. Nhấn Run (▶)

### Option 2: Script tự động
```bash
# Windows
cd example
CHAY_NHANH.bat

# Mac/Linux
cd example
chmod +x run.sh
./run.sh
```

### Option 3: Terminal
```bash
cd example
flutter pub get
flutter run
```

---

## ✅ KẾT QUẢ MONG ĐỢI

Sau khi chạy app, bạn sẽ thấy:

1. ✅ Giao diện đẹp, hiện đại
2. ✅ Grid cells 15x15 rõ ràng
3. ✅ Tap và drag hoạt động mượt mà
4. ✅ Cells được chọn hiển thị màu đỏ
5. ✅ Nút điều khiển hoạt động đúng
6. ✅ Mảng index hiển thị chính xác

---

## 🐛 TROUBLESHOOTING

### App không chạy được
→ Mở Android Studio và chạy từ đó

### Không thấy device
→ Tạo emulator trong Android Studio

### Build failed
→ Chạy `flutter clean` và `flutter pub get`

### Cells không chọn được
→ Kiểm tra `enableSelection: true` trong code

---

**Chúc bạn test thành công! 🎉**

