import 'package:flutter/material.dart';
import 'cells_controller.dart';
import 'cells_data_controller.dart';
import 'cells_data_widget.dart';
import 'cells_size_controller.dart';

/// Widget hiển thị dữ liệu dạng bảng (table) như Excel
/// Hỗ trợ hiển thị `List<List<String>>` hoặc `List<Map>`
class CellsTableWidget extends StatefulWidget {
  /// CellsController để quản lý grid
  final CellsController controller;
  
  /// CellsDataController để quản lý dữ liệu
  final CellsDataController? dataController;
  
  /// CellsSizeController để quản lý kích thước tùy chỉnh
  final CellsSizeController? sizeController;
  
  /// Dữ liệu dạng `List<List<String>>` (rows x columns)
  final List<List<String>>? data;
  
  /// Dữ liệu dạng `List<Map<String, dynamic>>`
  final List<Map<String, dynamic>>? mapData;
  
  /// Tên các cột (nếu dùng mapData)
  final List<String>? columns;
  
  /// Cho phép edit cells
  final bool enableEdit;
  
  /// Hiển thị header row
  final bool showHeader;
  
  /// Header background color
  final Color? headerBackgroundColor;
  
  /// Header text style
  final TextStyle? headerTextStyle;
  
  /// Cell border color
  final Color? borderColor;
  
  /// Cell border width
  final double? borderWidth;
  
  /// Default cell background color
  final Color? defaultCellColor;
  
  /// Callback khi data thay đổi
  final void Function(List<List<String>> data)? onDataChanged;

  const CellsTableWidget({
    super.key,
    required this.controller,
    this.dataController,
    this.sizeController,
    this.data,
    this.mapData,
    this.columns,
    this.enableEdit = false,
    this.showHeader = true,
    this.headerBackgroundColor,
    this.headerTextStyle,
    this.borderColor,
    this.borderWidth,
    this.defaultCellColor,
    this.onDataChanged,
  });

  @override
  State<CellsTableWidget> createState() => _CellsTableWidgetState();
}

class _CellsTableWidgetState extends State<CellsTableWidget> {
  late CellsDataController _dataController;
  bool _isInternalDataController = false;

  @override
  void initState() {
    super.initState();
    try {
      if (widget.dataController != null) {
        _dataController = widget.dataController!;
      } else {
        _dataController = CellsDataController(widget.controller);
        _isInternalDataController = true;
      }
      
      // Load data nếu có
      if (widget.data != null) {
        _dataController.loadData(widget.data!);
      } else if (widget.mapData != null) {
        _dataController.loadDataFromMaps(
          widget.mapData!,
          columns: widget.columns,
        );
      }
      
      _dataController.addListener(_onDataChanged);
    } catch (e) {
      _dataController = CellsDataController(widget.controller);
      _isInternalDataController = true;
    }
  }

  @override
  void didUpdateWidget(CellsTableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    try {
      // Reload data nếu thay đổi
      if (widget.data != null && widget.data != oldWidget.data) {
        _dataController.loadData(widget.data!);
      } else if (widget.mapData != null && widget.mapData != oldWidget.mapData) {
        _dataController.loadDataFromMaps(
          widget.mapData!,
          columns: widget.columns,
        );
      }
    } catch (e) {
      // Ignore error
    }
  }

  @override
  void dispose() {
    try {
      _dataController.removeListener(_onDataChanged);
      if (_isInternalDataController) {
        _dataController.dispose();
      }
    } catch (e) {
      // Ignore error
    }
    super.dispose();
  }

  void _onDataChanged() {
    try {
      if (mounted) {
        setState(() {});
        final exportedData = _dataController.exportData();
        widget.onDataChanged?.call(exportedData);
      }
    } catch (e) {
      // Ignore error
    }
  }

  @override
  Widget build(BuildContext context) {
      return CellsDataWidget(
        controller: widget.controller,
        dataController: _dataController,
        sizeController: widget.sizeController,
        enableEdit: widget.enableEdit,
        showHeader: widget.showHeader,
        headerBackgroundColor: widget.headerBackgroundColor,
        headerTextStyle: widget.headerTextStyle,
        borderColor: widget.borderColor,
        borderWidth: widget.borderWidth,
        defaultCellColor: widget.defaultCellColor,
        onCellTextChanged: (index, text) {
          _dataController.setCellText(index, text);
        },
      );
  }
}

