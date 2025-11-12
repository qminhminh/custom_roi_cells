# custom_roi_camera_cells

Flutter package để tạo grid cells với khả năng tùy chỉnh kích thước màn hình và số lượng cells. Hữu ích cho việc tạo ROI (Region of Interest) trong camera applications.

## Tính năng

- ✅ Tùy chỉnh kích thước màn hình (chiều rộng và chiều cao)
- ✅ Tùy chỉnh số lượng cells (số hàng và số cột)
- ✅ **Chọn cells bằng tap và drag** - Tap để chọn/bỏ chọn, drag để chọn nhiều cells
- ✅ **Highlight cells được chọn** - Cells được chọn sẽ được highlight với màu đỏ
- ✅ **Lưu selection dưới dạng mảng index** - Ví dụ: [0,1,2,3,...]
- ✅ Widget với form input để nhập thông số
- ✅ Controller để quản lý trạng thái
- ✅ Callback khi cell được chọn
- ✅ Tùy chỉnh màu sắc, border, và hiển thị số thứ tự cell
- ✅ Nút điều khiển: Save, Delete, Clear selection
- ✅ Responsive và dễ sử dụng

## Cài đặt

Thêm vào file `pubspec.yaml`:

```yaml
dependencies:
  custom_roi_camera_cells: ^0.1.0
```

Sau đó chạy:

```bash
flutter pub get
```

## Sử dụng

### Cách 1: Sử dụng với Controller

```dart
import 'package:custom_roi_camera_cells/custom_roi_camera_cells.dart';

class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  // Khởi tạo controller với tham số tùy chỉnh
  final CellsController controller = CellsController(
    screenWidth: 2048.0,
    screenHeight: 500.0,
    cellsRows: 32,
    cellsColumns: 23,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CellsWidget(
      controller: controller,
      borderColor: Colors.blue,
      borderWidth: 1.0,
      cellColor: Colors.grey.withOpacity(0.1),
      onCellTap: (row, column) {
        print('Cell được chọn: Row $row, Column $column');
      },
    );
  }
}
```


### Cách 2: Sử dụng trực tiếp với tham số

```dart
CellsWidget(
  screenWidth: 2048.0,
  screenHeight: 500.0,
  cellsRows: 32,
  cellsColumns: 23,
  borderColor: Colors.blue,
  borderWidth: 0.5,
  showCellNumbers: true,
  onCellTap: (row, column) {
    print('Cell tại row $row, column $column');
  },
)
```

### Cách 3: Sử dụng với Selection (Tap và Drag để chọn cells)

```dart
final CellsController controller = CellsController(
  screenWidth: 800.0,
  screenHeight: 400.0,
  cellsRows: 20,
  cellsColumns: 20,
);

List<int> selectedIndices = [];

CellsWidget(
  controller: controller,
  enableSelection: true, // Bật chức năng selection
  selectedCellColor: Colors.red.withOpacity(0.6),
  showCellNumbers: true, // Hiển thị index của cells
  onSelectionChanged: (indices) {
    selectedIndices = indices;
    print('Đã chọn: $indices');
  },
)

// Nút điều khiển selection
CellsSelectionButtons(
  controller: controller,
  onSave: (indices) {
    print('Đã lưu: $indices');
    // indices là mảng [0,1,2,3,...]
  },
  onDelete: (indices) {
    print('Đã xóa: $indices');
  },
  onClear: () {
    print('Đã xóa tất cả selection');
  },
)
```

### Cách 4: Sử dụng Widget với Form Input

```dart
CellsInputWidget(
  controller: controller,
  showCellsPreview: true,
  onChanged: (width, height, rows, columns) {
    print('Width: $width, Height: $height');
    print('Rows: $rows, Columns: $columns');
  },
)
```

## API Reference

### CellsWidget

Widget chính để hiển thị grid cells.

**Tham số:**

- `controller` (CellsController?): Controller để quản lý trạng thái
- `screenWidth` (double?): Chiều rộng màn hình
- `screenHeight` (double?): Chiều cao màn hình
- `cellsRows` (int?): Số hàng cells
- `cellsColumns` (int?): Số cột cells
- `borderColor` (Color?): Màu border (mặc định: Colors.grey)
- `borderWidth` (double?): Độ dày border (mặc định: 1.0)
- `cellColor` (Color?): Màu nền cells (mặc định: Colors.transparent)
- `onCellTap` (void Function(int row, int column)?): Callback khi cell được chọn
- `showCellNumbers` (bool): Hiển thị số thứ tự cell (mặc định: false)
- `numberColor` (Color?): Màu chữ số thứ tự
- `numberFontSize` (double?): Kích thước chữ số thứ tự
- `enableSelection` (bool): Cho phép chọn cells bằng tap và drag (mặc định: false)
- `selectedCellColor` (Color?): Màu của cells được chọn (mặc định: Colors.red.withOpacity(0.5))
- `onSelectionChanged` (void Function(List<int> selectedIndices)?): Callback khi selection thay đổi, trả về danh sách index
- `onSaveSelection` (void Function(List<int> selectedIndices)?): Callback khi save selection

### CellsSelectionButtons

Widget hiển thị các nút điều khiển selection (Save, Delete, Clear).

**Tham số:**

- `controller` (CellsController): Controller để quản lý (bắt buộc)
- `onSave` (void Function(List<int> selectedIndices)?): Callback khi nhấn nút Save
- `onDelete` (void Function(List<int> selectedIndices)?): Callback khi nhấn nút Delete
- `onClear` (VoidCallback?): Callback khi nhấn nút Clear
- `saveButtonColor` (Color?): Màu nền nút Save (mặc định: Colors.blue)
- `deleteButtonColor` (Color?): Màu nền nút Delete (mặc định: Colors.black87)
- `clearButtonColor` (Color?): Màu nền nút Clear (mặc định: Colors.grey)
- `showSelectionCount` (bool): Hiển thị số lượng cells được chọn (mặc định: true)

### CellsInputWidget

Widget với form input để nhập thông số và hiển thị preview.

**Tham số:**

- `controller` (CellsController?): Controller để quản lý
- `onChanged` (void Function(double width, double height, int rows, int columns)?): Callback khi giá trị thay đổi
- `showCellsPreview` (bool): Hiển thị preview cells (mặc định: true)

### CellsController

Controller để quản lý trạng thái của cells.

**Constructor:**

```dart
CellsController({
  required double screenWidth,    // Bắt buộc, phải > 0
  required double screenHeight,   // Bắt buộc, phải > 0
  required int cellsRows,         // Bắt buộc, phải > 0
  required int cellsColumns,      // Bắt buộc, phải > 0
})
```

**Lưu ý:** Tất cả các tham số đều bắt buộc và phải lớn hơn 0. Nếu truyền giá trị <= 0, sẽ ném `ArgumentError`.

**Thuộc tính:**

- `screenWidth` (double): Chiều rộng màn hình
- `screenHeight` (double): Chiều cao màn hình
- `cellsRows` (int): Số hàng cells
- `cellsColumns` (int): Số cột cells
- `cellWidth` (double): Kích thước chiều rộng mỗi cell (read-only)
- `cellHeight` (double): Kích thước chiều cao mỗi cell (read-only)
- `totalCells` (int): Tổng số cells (read-only)
- `selectedCellIndices` (Set<int>): Danh sách index các cells được chọn (read-only)
- `selectedCellsCount` (int): Số lượng cells được chọn (read-only)

**Phương thức:**

- `isCellSelected(int index)`: Kiểm tra cell có được chọn không
- `selectCell(int index)`: Chọn một cell theo index
- `deselectCell(int index)`: Bỏ chọn một cell theo index
- `selectCells(List<int> indices)`: Chọn nhiều cells theo danh sách index
- `selectCellRange(int startIndex, int endIndex)`: Chọn một range cells
- `selectRow(int row)`: Chọn toàn bộ một hàng
- `selectColumn(int column)`: Chọn toàn bộ một cột
- `clearSelection()`: Xóa tất cả selection
- `deleteSelectedCells()`: Xóa các cells được chọn
- `getSelectedIndices()`: Lấy danh sách index đã chọn dưới dạng mảng đã sắp xếp
- `addListener(void Function() listener)`: Đăng ký listener
- `removeListener(void Function() listener)`: Hủy đăng ký listener
- `dispose()`: Giải phóng tài nguyên

## Ví dụ

Xem thêm ví dụ chi tiết trong thư mục `example/`.

## Đóng góp

Đóng góp và đề xuất đều được chào đón! Vui lòng tạo issue hoặc pull request trên GitHub.

## License

MIT License - xem file [LICENSE](LICENSE) để biết thêm chi tiết.

## Tác giả

Được tạo bởi [Tên của bạn]
