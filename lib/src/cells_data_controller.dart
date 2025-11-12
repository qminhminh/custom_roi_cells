import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'cells_controller.dart';

/// Dữ liệu của một cell
class CellData {
  /// Text trong cell
  String text;
  
  /// Màu nền của cell
  Color? backgroundColor;
  
  /// Màu chữ
  Color? textColor;
  
  /// Font size
  double? fontSize;
  
  /// Font weight
  FontWeight? fontWeight;
  
  /// Text alignment
  TextAlign? textAlign;
  
  /// Cell có được merge không
  bool isMerged;
  
  /// Row span nếu merged
  int rowSpan;
  
  /// Column span nếu merged
  int colSpan;

  CellData({
    this.text = '',
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.isMerged = false,
    this.rowSpan = 1,
    this.colSpan = 1,
  });

  CellData copyWith({
    String? text,
    Color? backgroundColor,
    Color? textColor,
    double? fontSize,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    bool? isMerged,
    int? rowSpan,
    int? colSpan,
  }) {
    return CellData(
      text: text ?? this.text,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      textAlign: textAlign ?? this.textAlign,
      isMerged: isMerged ?? this.isMerged,
      rowSpan: rowSpan ?? this.rowSpan,
      colSpan: colSpan ?? this.colSpan,
    );
  }
}

/// Controller để quản lý dữ liệu trong cells (như Excel)
class CellsDataController extends ChangeNotifier {
  final CellsController _cellsController;
  final Map<int, CellData> _cellDataMap = {};
  final Map<int, String> _cellTextMap = {}; // Map index -> text (đơn giản hóa)

  CellsDataController(this._cellsController) {
    _cellsController.addListener(_onCellsControllerChanged);
  }

  void _onCellsControllerChanged() {
    try {
      // Xóa dữ liệu của cells vượt quá totalCells
      final totalCells = _cellsController.totalCells;
      _cellDataMap.removeWhere((index, _) => index >= totalCells);
      _cellTextMap.removeWhere((index, _) => index >= totalCells);
      notifyListeners();
    } catch (e) {
      // Ignore error
    }
  }

  /// Lấy text của cell theo index
  String getCellText(int index) {
    try {
      if (index < 0 || index >= _cellsController.totalCells) return '';
      return _cellTextMap[index] ?? '';
    } catch (e) {
      return '';
    }
  }

  /// Đặt text cho cell theo index
  void setCellText(int index, String text) {
    try {
      if (index >= 0 && index < _cellsController.totalCells) {
        _cellTextMap[index] = text;
        notifyListeners();
      }
    } catch (e) {
      // Ignore error
    }
  }

  /// Lấy CellData của cell theo index
  CellData? getCellData(int index) {
    try {
      if (index < 0 || index >= _cellsController.totalCells) return null;
      return _cellDataMap[index] ?? CellData(text: getCellText(index));
    } catch (e) {
      return null;
    }
  }

  /// Đặt CellData cho cell theo index
  void setCellData(int index, CellData cellData) {
    try {
      if (index >= 0 && index < _cellsController.totalCells) {
        _cellDataMap[index] = cellData;
        _cellTextMap[index] = cellData.text;
        notifyListeners();
      }
    } catch (e) {
      // Ignore error
    }
  }

  /// Load dữ liệu từ List<List<String>> (như Excel rows/columns)
  void loadData(List<List<String>> data) {
    try {
      _cellTextMap.clear();
      _cellDataMap.clear();
      
      for (int row = 0; row < data.length && row < _cellsController.cellsRows; row++) {
        final rowData = data[row];
        for (int col = 0; col < rowData.length && col < _cellsController.cellsColumns; col++) {
          final index = row * _cellsController.cellsColumns + col;
          if (index < _cellsController.totalCells) {
            _cellTextMap[index] = rowData[col];
          }
        }
      }
      notifyListeners();
    } catch (e) {
      // Ignore error
    }
  }

  /// Load dữ liệu từ List<Map<String, dynamic>> (như danh sách objects)
  void loadDataFromMaps(List<Map<String, dynamic>> data, {List<String>? columns}) {
    try {
      _cellTextMap.clear();
      _cellDataMap.clear();
      
      // Header row (nếu có columns)
      if (columns != null && columns.isNotEmpty) {
        for (int col = 0; col < columns.length && col < _cellsController.cellsColumns; col++) {
          _cellTextMap[col] = columns[col];
          // Style header
          _cellDataMap[col] = CellData(
            text: columns[col],
            fontWeight: FontWeight.bold,
            backgroundColor: const Color(0xFFE0E0E0),
          );
        }
      }
      
      // Data rows
      int startRow = columns != null ? 1 : 0;
      for (int row = 0; row < data.length && (startRow + row) < _cellsController.cellsRows; row++) {
        final rowData = data[row];
        final values = columns != null
            ? columns.map((col) => rowData[col]?.toString() ?? '').toList()
            : rowData.values.map((v) => v?.toString() ?? '').toList();
        
        for (int col = 0; col < values.length && col < _cellsController.cellsColumns; col++) {
          final index = (startRow + row) * _cellsController.cellsColumns + col;
          if (index < _cellsController.totalCells) {
            _cellTextMap[index] = values[col];
          }
        }
      }
      notifyListeners();
    } catch (e) {
      // Ignore error
    }
  }

  /// Export dữ liệu ra List<List<String>>
  List<List<String>> exportData() {
    try {
      final List<List<String>> result = [];
      for (int row = 0; row < _cellsController.cellsRows; row++) {
        final List<String> rowData = [];
        for (int col = 0; col < _cellsController.cellsColumns; col++) {
          final index = row * _cellsController.cellsColumns + col;
          rowData.add(getCellText(index));
        }
        result.add(rowData);
      }
      return result;
    } catch (e) {
      return [];
    }
  }

  /// Export dữ liệu ra JSON
  Map<String, dynamic> exportToJson() {
    try {
      final data = exportData();
      return {
        'rows': _cellsController.cellsRows,
        'columns': _cellsController.cellsColumns,
        'data': data,
      };
    } catch (e) {
      return {};
    }
  }

  /// Import dữ liệu từ JSON
  void importFromJson(Map<String, dynamic> json) {
    try {
      final data = json['data'] as List<dynamic>?;
      if (data != null) {
        final List<List<String>> listData = data
            .map((row) => (row as List<dynamic>).map((cell) => cell.toString()).toList())
            .toList();
        loadData(listData);
      }
    } catch (e) {
      // Ignore error
    }
  }

  /// Export dữ liệu ra CSV format (String)
  String exportToCsv() {
    try {
      final data = exportData();
      return data.map((row) => row.join(',')).join('\n');
    } catch (e) {
      return '';
    }
  }

  /// Clear tất cả dữ liệu
  void clearData() {
    try {
      _cellTextMap.clear();
      _cellDataMap.clear();
      notifyListeners();
    } catch (e) {
      // Ignore error
    }
  }

  /// Clear text của cell
  void clearCell(int index) {
    try {
      _cellTextMap.remove(index);
      _cellDataMap.remove(index);
      notifyListeners();
    } catch (e) {
      // Ignore error
    }
  }

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

