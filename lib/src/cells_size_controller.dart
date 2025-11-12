import 'package:flutter/foundation.dart';
import 'cells_controller.dart';

/// Controller để quản lý kích thước tùy chỉnh của các cột và hàng
class CellsSizeController extends ChangeNotifier {
  final CellsController _cellsController;
  
  /// Map column index -> width (null = sử dụng kích thước mặc định)
  final Map<int, double> _columnWidths = {};
  
  /// Map row index -> height (null = sử dụng kích thước mặc định)
  final Map<int, double> _rowHeights = {};
  
  /// Cho phép kích thước tùy chỉnh
  bool _enableCustomSizes = false;

  CellsSizeController(this._cellsController) {
    _cellsController.addListener(_onCellsControllerChanged);
  }

  void _onCellsControllerChanged() {
    try {
      // Xóa kích thước của các cột/hàng vượt quá giới hạn
      final maxColumns = _cellsController.cellsColumns;
      final maxRows = _cellsController.cellsRows;
      
      _columnWidths.removeWhere((col, _) => col >= maxColumns);
      _rowHeights.removeWhere((row, _) => row >= maxRows);
      
      notifyListeners();
    } catch (e) {
      // Ignore error
    }
  }

  /// Bật/tắt kích thước tùy chỉnh
  bool get enableCustomSizes => _enableCustomSizes;
  set enableCustomSizes(bool value) {
    try {
      _enableCustomSizes = value;
      notifyListeners();
    } catch (e) {
      // Ignore error
    }
  }

  /// Lấy chiều rộng của cột (trả về null nếu sử dụng mặc định)
  double? getColumnWidth(int columnIndex) {
    try {
      if (columnIndex < 0 || columnIndex >= _cellsController.cellsColumns) {
        return null;
      }
      return _columnWidths[columnIndex];
    } catch (e) {
      return null;
    }
  }

  /// Đặt chiều rộng của cột
  void setColumnWidth(int columnIndex, double? width) {
    try {
      if (columnIndex < 0 || columnIndex >= _cellsController.cellsColumns) {
        return;
      }
      
      if (width == null || width <= 0) {
        _columnWidths.remove(columnIndex);
      } else {
        _columnWidths[columnIndex] = width;
      }
      notifyListeners();
    } catch (e) {
      // Ignore error
    }
  }

  /// Lấy chiều cao của hàng (trả về null nếu sử dụng mặc định)
  double? getRowHeight(int rowIndex) {
    try {
      if (rowIndex < 0 || rowIndex >= _cellsController.cellsRows) {
        return null;
      }
      return _rowHeights[rowIndex];
    } catch (e) {
      return null;
    }
  }

  /// Đặt chiều cao của hàng
  void setRowHeight(int rowIndex, double? height) {
    try {
      if (rowIndex < 0 || rowIndex >= _cellsController.cellsRows) {
        return;
      }
      
      if (height == null || height <= 0) {
        _rowHeights.remove(rowIndex);
      } else {
        _rowHeights[rowIndex] = height;
      }
      notifyListeners();
    } catch (e) {
      // Ignore error
    }
  }

  /// Tính tổng chiều rộng của tất cả các cột
  double get totalWidth {
    try {
      if (!_enableCustomSizes || _columnWidths.isEmpty) {
        return _cellsController.screenWidth;
      }
      
      double total = 0.0;
      final defaultWidth = _cellsController.cellWidth;
      
      for (int i = 0; i < _cellsController.cellsColumns; i++) {
        total += _columnWidths[i] ?? defaultWidth;
      }
      
      return total;
    } catch (e) {
      return _cellsController.screenWidth;
    }
  }

  /// Tính tổng chiều cao của tất cả các hàng
  double get totalHeight {
    try {
      if (!_enableCustomSizes || _rowHeights.isEmpty) {
        return _cellsController.screenHeight;
      }
      
      double total = 0.0;
      final defaultHeight = _cellsController.cellHeight;
      
      for (int i = 0; i < _cellsController.cellsRows; i++) {
        total += _rowHeights[i] ?? defaultHeight;
      }
      
      return total;
    } catch (e) {
      return _cellsController.screenHeight;
    }
  }

  /// Tính chiều rộng thực tế của cột
  double getColumnActualWidth(int columnIndex) {
    try {
      if (!_enableCustomSizes) {
        return _cellsController.cellWidth;
      }
      return getColumnWidth(columnIndex) ?? _cellsController.cellWidth;
    } catch (e) {
      return _cellsController.cellWidth;
    }
  }

  /// Tính chiều cao thực tế của hàng
  double getRowActualHeight(int rowIndex) {
    try {
      if (!_enableCustomSizes) {
        return _cellsController.cellHeight;
      }
      return getRowHeight(rowIndex) ?? _cellsController.cellHeight;
    } catch (e) {
      return _cellsController.cellHeight;
    }
  }

  /// Reset tất cả kích thước về mặc định
  void resetAllSizes() {
    try {
      _columnWidths.clear();
      _rowHeights.clear();
      notifyListeners();
    } catch (e) {
      // Ignore error
    }
  }

  /// Reset kích thước của một cột
  void resetColumnWidth(int columnIndex) {
    try {
      _columnWidths.remove(columnIndex);
      notifyListeners();
    } catch (e) {
      // Ignore error
    }
  }

  /// Reset kích thước của một hàng
  void resetRowHeight(int rowIndex) {
    try {
      _rowHeights.remove(rowIndex);
      notifyListeners();
    } catch (e) {
      // Ignore error
    }
  }

  /// Lấy tất cả kích thước cột
  Map<int, double> get allColumnWidths => Map.unmodifiable(_columnWidths);

  /// Lấy tất cả kích thước hàng
  Map<int, double> get allRowHeights => Map.unmodifiable(_rowHeights);

  @override
  void dispose() {
    try {
      _cellsController.removeListener(_onCellsControllerChanged);
    } catch (e) {
      // Ignore error
    }
    super.dispose();
  }
}

