/// Controller để quản lý trạng thái của Cells widget
class CellsController {
  double _screenWidth;
  double _screenHeight;
  int _cellsRows;
  int _cellsColumns;

  /// Constructor để khởi tạo CellsController với các tham số bắt buộc
  ///
  /// [screenWidth] - Chiều rộng màn hình (bắt buộc, phải > 0)
  /// [screenHeight] - Chiều cao màn hình (bắt buộc, phải > 0)
  /// [cellsRows] - Số hàng cells (bắt buộc, phải > 0)
  /// [cellsColumns] - Số cột cells (bắt buộc, phải > 0)
  ///
  /// Ném [ArgumentError] nếu bất kỳ giá trị nào <= 0
  CellsController({
    required double screenWidth,
    required double screenHeight,
    required int cellsRows,
    required int cellsColumns,
  }) : _screenWidth =
           screenWidth > 0
               ? screenWidth
               : throw ArgumentError(
                 'screenWidth phải lớn hơn 0, nhận được: $screenWidth',
               ),
       _screenHeight =
           screenHeight > 0
               ? screenHeight
               : throw ArgumentError(
                 'screenHeight phải lớn hơn 0, nhận được: $screenHeight',
               ),
       _cellsRows =
           cellsRows > 0
               ? cellsRows
               : throw ArgumentError(
                 'cellsRows phải lớn hơn 0, nhận được: $cellsRows',
               ),
       _cellsColumns =
           cellsColumns > 0
               ? cellsColumns
               : throw ArgumentError(
                 'cellsColumns phải lớn hơn 0, nhận được: $cellsColumns',
               );

  /// Chiều rộng màn hình
  double get screenWidth => _screenWidth;
  set screenWidth(double value) {
    try {
      if (value > 0) {
        _screenWidth = value;
        _notifyListeners();
      }
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  /// Chiều cao màn hình
  double get screenHeight => _screenHeight;
  set screenHeight(double value) {
    try {
      if (value > 0) {
        _screenHeight = value;
        _notifyListeners();
      }
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  /// Số hàng cells
  int get cellsRows => _cellsRows;
  set cellsRows(int value) {
    try {
      if (value > 0) {
        final oldTotalCells = totalCells;
        _cellsRows = value;
        final newTotalCells = totalCells;
        // Xóa selection nếu index vượt quá totalCells mới
        if (newTotalCells < oldTotalCells) {
          _selectedCellIndices.removeWhere((index) => index >= newTotalCells);
        }
        _notifyListeners();
      }
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  /// Số cột cells
  int get cellsColumns => _cellsColumns;
  set cellsColumns(int value) {
    try {
      if (value > 0) {
        final oldTotalCells = totalCells;
        _cellsColumns = value;
        final newTotalCells = totalCells;
        // Xóa selection nếu index vượt quá totalCells mới
        if (newTotalCells < oldTotalCells) {
          _selectedCellIndices.removeWhere((index) => index >= newTotalCells);
        }
        _notifyListeners();
      }
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  /// Kích thước của mỗi cell (chiều rộng)
  double get cellWidth {
    try {
      if (_cellsColumns <= 0) return 0.0;
      return _screenWidth / _cellsColumns;
    } catch (e) {
      return 0.0;
    }
  }

  /// Kích thước của mỗi cell (chiều cao)
  double get cellHeight {
    try {
      if (_cellsRows <= 0) return 0.0;
      return _screenHeight / _cellsRows;
    } catch (e) {
      return 0.0;
    }
  }

  /// Tổng số cells
  int get totalCells {
    try {
      return _cellsRows * _cellsColumns;
    } catch (e) {
      return 0;
    }
  }

  /// Danh sách index các cells được chọn
  final Set<int> _selectedCellIndices = <int>{};

  /// Danh sách index các cells được chọn (read-only)
  Set<int> get selectedCellIndices => Set.unmodifiable(_selectedCellIndices);

  /// Số lượng cells được chọn
  int get selectedCellsCount => _selectedCellIndices.length;

  /// Kiểm tra cell có được chọn không
  bool isCellSelected(int index) {
    try {
      if (index < 0 || index >= totalCells) return false;
      return _selectedCellIndices.contains(index);
    } catch (e) {
      return false;
    }
  }

  /// Chọn một cell theo index
  void selectCell(int index) {
    try {
      if (index >= 0 && index < totalCells) {
        _selectedCellIndices.add(index);
        _notifyListeners();
      }
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  /// Bỏ chọn một cell theo index
  void deselectCell(int index) {
    try {
      _selectedCellIndices.remove(index);
      _notifyListeners();
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  /// Chọn nhiều cells theo danh sách index
  void selectCells(List<int> indices) {
    try {
      for (final index in indices) {
        if (index >= 0 && index < totalCells) {
          _selectedCellIndices.add(index);
        }
      }
      _notifyListeners();
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  /// Gán danh sách cells được chọn (thay thế toàn bộ selection hiện tại)
  void setSelectedCells(List<int> indices) {
    try {
      _selectedCellIndices.clear();
      for (final index in indices) {
        if (index >= 0 && index < totalCells) {
          _selectedCellIndices.add(index);
        }
      }
      _notifyListeners();
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  /// Chọn một range cells từ startIndex đến endIndex
  void selectCellRange(int startIndex, int endIndex) {
    try {
      final start = startIndex < endIndex ? startIndex : endIndex;
      final end = startIndex > endIndex ? startIndex : endIndex;

      for (int i = start; i <= end; i++) {
        if (i >= 0 && i < totalCells) {
          _selectedCellIndices.add(i);
        }
      }
      _notifyListeners();
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  /// Bỏ chọn một range cells từ startIndex đến endIndex
  void deselectCellRange(int startIndex, int endIndex) {
    try {
      final start = startIndex < endIndex ? startIndex : endIndex;
      final end = startIndex > endIndex ? startIndex : endIndex;

      for (int i = start; i <= end; i++) {
        if (i >= 0 && i < totalCells) {
          _selectedCellIndices.remove(i);
        }
      }
      _notifyListeners();
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  /// Toggle selection của một range cells (chọn nếu chưa chọn, bỏ chọn nếu đã chọn)
  void toggleCellRange(int startIndex, int endIndex, bool selectMode) {
    try {
      if (selectMode) {
        selectCellRange(startIndex, endIndex);
      } else {
        deselectCellRange(startIndex, endIndex);
      }
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  /// Chọn cells theo hàng (row)
  void selectRow(int row) {
    try {
      if (row >= 0 && row < _cellsRows) {
        final startIndex = row * _cellsColumns;
        final endIndex = startIndex + _cellsColumns - 1;
        selectCellRange(startIndex, endIndex);
      }
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  /// Chọn cells theo cột (column)
  void selectColumn(int column) {
    try {
      if (column >= 0 && column < _cellsColumns) {
        for (int row = 0; row < _cellsRows; row++) {
          final index = row * _cellsColumns + column;
          if (index >= 0 && index < totalCells) {
            _selectedCellIndices.add(index);
          }
        }
        _notifyListeners();
      }
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  /// Xóa tất cả selection
  void clearSelection() {
    try {
      _selectedCellIndices.clear();
      _notifyListeners();
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  /// Xóa các cells được chọn
  void deleteSelectedCells() {
    try {
      _selectedCellIndices.clear();
      _notifyListeners();
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  /// Lấy danh sách index đã chọn dưới dạng mảng đã sắp xếp
  List<int> getSelectedIndices() {
    try {
      return _selectedCellIndices.toList()..sort();
    } catch (e) {
      return [];
    }
  }

  final List<void Function()> _listeners = [];

  /// Đăng ký listener để nhận thông báo khi có thay đổi
  void addListener(void Function() listener) {
    try {
      if (!_listeners.contains(listener)) {
        _listeners.add(listener);
      }
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  /// Hủy đăng ký listener
  void removeListener(void Function() listener) {
    try {
      _listeners.remove(listener);
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  void _notifyListeners() {
    try {
      // Tạo bản sao để tránh lỗi nếu listener bị thay đổi trong khi iterate
      final listeners = List<void Function()>.from(_listeners);
      for (final listener in listeners) {
        try {
          listener();
        } catch (e) {
          // Ignore lỗi từ listener để tránh ảnh hưởng đến các listener khác
        }
      }
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  /// Dispose controller
  void dispose() {
    try {
      _listeners.clear();
      _selectedCellIndices.clear();
    } catch (e) {
      // Ignore error khi dispose
    }
  }
}
