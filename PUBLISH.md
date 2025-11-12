# Hướng dẫn Publish Package lên pub.dev

## Bước 1: Chuẩn bị

1. Đảm bảo đã cài đặt Flutter SDK
2. Đăng nhập vào pub.dev bằng tài khoản Google
3. Kiểm tra tất cả các file cần thiết:
   - `pubspec.yaml` - đã cập nhật mô tả và version
   - `README.md` - đã có hướng dẫn đầy đủ
   - `CHANGELOG.md` - đã có changelog
   - `LICENSE` - đã có license (MIT)
   - `example/` - đã có example app

## Bước 2: Kiểm tra code

Chạy các lệnh sau để kiểm tra:

```bash
# Format code
flutter format .

# Analyze code
flutter analyze

# Chạy tests
flutter test

# Chạy example app
cd example
flutter run
```

## Bước 3: Cập nhật thông tin trong pubspec.yaml

Đảm bảo các thông tin sau đã đúng:
- `name`: Tên package (phải là unique trên pub.dev)
- `description`: Mô tả ngắn gọn (tối đa 60 ký tự)
- `version`: Version hiện tại
- `homepage`: URL GitHub repository
- `repository`: URL GitHub repository
- `issue_tracker`: URL GitHub issues

**Lưu ý:** Cập nhật các URL GitHub trong `pubspec.yaml` với repository thực tế của bạn.

## Bước 4: Tạo tài khoản pub.dev

1. Truy cập https://pub.dev
2. Đăng nhập bằng tài khoản Google
3. Vào phần "Publisher" để tạo publisher (nếu chưa có)

## Bước 5: Publish package

```bash
# Kiểm tra package trước khi publish
flutter pub publish --dry-run

# Publish package
flutter pub publish
```

## Bước 6: Sau khi publish

1. Kiểm tra package trên pub.dev
2. Cập nhật README nếu cần
3. Tạo tags trên GitHub:
   ```bash
   git tag v0.1.0
   git push origin v0.1.0
   ```

## Lưu ý quan trọng

- **Version**: Mỗi lần publish phải tăng version
- **Changelog**: Luôn cập nhật CHANGELOG.md khi có thay đổi
- **Tests**: Đảm bảo tất cả tests đều pass
- **Documentation**: Đảm bảo README.md đầy đủ và rõ ràng
- **License**: Phải có license file

## Cập nhật package sau khi publish

1. Cập nhật version trong `pubspec.yaml`
2. Cập nhật `CHANGELOG.md`
3. Commit và push code
4. Chạy `flutter pub publish`
5. Tạo tag mới trên GitHub

## Troubleshooting

- **Lỗi "Package already exists"**: Tên package đã được sử dụng, cần đổi tên
- **Lỗi "Invalid version"**: Version không đúng format (phải là x.y.z)
- **Lỗi "Missing files"**: Thiếu file cần thiết (README, LICENSE, etc.)

