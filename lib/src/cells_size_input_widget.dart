import 'package:flutter/material.dart';
import 'cells_controller.dart';
import 'cells_size_controller.dart';

/// Widget để người dùng nhập kích thước tùy chỉnh cho các cột và hàng
class CellsSizeInputWidget extends StatefulWidget {
  /// CellsController để quản lý grid
  final CellsController controller;
  
  /// CellsSizeController để quản lý kích thước
  final CellsSizeController? sizeController;
  
  /// Callback khi kích thước thay đổi
  final void Function(int index, double? size, bool isColumn)? onSizeChanged;

  const CellsSizeInputWidget({
    super.key,
    required this.controller,
    this.sizeController,
    this.onSizeChanged,
  });

  @override
  State<CellsSizeInputWidget> createState() => _CellsSizeInputWidgetState();
}

class _CellsSizeInputWidgetState extends State<CellsSizeInputWidget> {
  late CellsSizeController _sizeController;
  bool _isInternalSizeController = false;
  final Map<int, TextEditingController> _columnWidthControllers = {};
  final Map<int, TextEditingController> _rowHeightControllers = {};
  int _selectedTab = 0; // 0 = Columns, 1 = Rows

  @override
  void initState() {
    super.initState();
    try {
      if (widget.sizeController != null) {
        _sizeController = widget.sizeController!;
      } else {
        _sizeController = CellsSizeController(widget.controller);
        _isInternalSizeController = true;
      }
      _sizeController.enableCustomSizes = true;
      _sizeController.addListener(_onSizeChanged);
      _initializeControllers();
    } catch (e) {
      _sizeController = CellsSizeController(widget.controller);
      _isInternalSizeController = true;
      _sizeController.enableCustomSizes = true;
    }
  }

  void _initializeControllers() {
    try {
      // Khởi tạo controllers cho các cột
      for (int i = 0; i < widget.controller.cellsColumns; i++) {
        final width = _sizeController.getColumnWidth(i);
        _columnWidthControllers[i] = TextEditingController(
          text: width != null ? width.toStringAsFixed(1) : '',
        );
      }
      
      // Khởi tạo controllers cho các hàng
      for (int i = 0; i < widget.controller.cellsRows; i++) {
        final height = _sizeController.getRowHeight(i);
        _rowHeightControllers[i] = TextEditingController(
          text: height != null ? height.toStringAsFixed(1) : '',
        );
      }
    } catch (e) {
      // Ignore error
    }
  }

  @override
  void dispose() {
    try {
      _sizeController.removeListener(_onSizeChanged);
      for (final controller in _columnWidthControllers.values) {
        controller.dispose();
      }
      for (final controller in _rowHeightControllers.values) {
        controller.dispose();
      }
      if (_isInternalSizeController) {
        _sizeController.dispose();
      }
    } catch (e) {
      // Ignore error
    }
    super.dispose();
  }

  void _onSizeChanged() {
    try {
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      // Ignore error
    }
  }

  void _onColumnWidthChanged(int columnIndex, String value) {
    try {
      final width = double.tryParse(value);
      _sizeController.setColumnWidth(columnIndex, width);
      widget.onSizeChanged?.call(columnIndex, width, true);
    } catch (e) {
      // Ignore error
    }
  }

  void _onRowHeightChanged(int rowIndex, String value) {
    try {
      final height = double.tryParse(value);
      _sizeController.setRowHeight(rowIndex, height);
      widget.onSizeChanged?.call(rowIndex, height, false);
    } catch (e) {
      // Ignore error
    }
  }

  void _resetColumnWidth(int columnIndex) {
    try {
      _sizeController.resetColumnWidth(columnIndex);
      _columnWidthControllers[columnIndex]?.text = '';
      widget.onSizeChanged?.call(columnIndex, null, true);
    } catch (e) {
      // Ignore error
    }
  }

  void _resetRowHeight(int rowIndex) {
    try {
      _sizeController.resetRowHeight(rowIndex);
      _rowHeightControllers[rowIndex]?.text = '';
      widget.onSizeChanged?.call(rowIndex, null, false);
    } catch (e) {
      // Ignore error
    }
  }

  void _resetAllSizes() {
    try {
      _sizeController.resetAllSizes();
      _initializeControllers();
      setState(() {});
    } catch (e) {
      // Ignore error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab bar
        Row(
          children: [
            Expanded(
              child: SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 0, label: Text('Columns')),
                  ButtonSegment(value: 1, label: Text('Rows')),
                ],
                selected: {_selectedTab},
                onSelectionChanged: (Set<int> newSelection) {
                  setState(() {
                    _selectedTab = newSelection.first;
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: _resetAllSizes,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Content
        Expanded(
          child: _selectedTab == 0
              ? _buildColumnsTab()
              : _buildRowsTab(),
        ),
      ],
    );
  }

  Widget _buildColumnsTab() {
    final defaultWidth = widget.controller.cellWidth;
    
    return ListView.builder(
      itemCount: widget.controller.cellsColumns,
      itemBuilder: (context, index) {
        final width = _sizeController.getColumnWidth(index);
        final actualWidth = _sizeController.getColumnActualWidth(index);
        
        if (!_columnWidthControllers.containsKey(index)) {
          _columnWidthControllers[index] = TextEditingController(
            text: width != null ? width.toStringAsFixed(1) : '',
          );
        }
        
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    'Column $index',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _columnWidthControllers[index],
                    decoration: InputDecoration(
                      labelText: 'Width',
                      hintText: 'Default: ${defaultWidth.toStringAsFixed(1)}',
                      border: const OutlineInputBorder(),
                      suffixText: 'px',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) => _onColumnWidthChanged(index, value),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Actual: ${actualWidth.toStringAsFixed(1)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                if (width != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _resetColumnWidth(index),
                    tooltip: 'Reset to default',
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRowsTab() {
    final defaultHeight = widget.controller.cellHeight;
    
    return ListView.builder(
      itemCount: widget.controller.cellsRows,
      itemBuilder: (context, index) {
        final height = _sizeController.getRowHeight(index);
        final actualHeight = _sizeController.getRowActualHeight(index);
        
        if (!_rowHeightControllers.containsKey(index)) {
          _rowHeightControllers[index] = TextEditingController(
            text: height != null ? height.toStringAsFixed(1) : '',
          );
        }
        
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    'Row $index',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _rowHeightControllers[index],
                    decoration: InputDecoration(
                      labelText: 'Height',
                      hintText: 'Default: ${defaultHeight.toStringAsFixed(1)}',
                      border: const OutlineInputBorder(),
                      suffixText: 'px',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) => _onRowHeightChanged(index, value),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Actual: ${actualHeight.toStringAsFixed(1)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                if (height != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _resetRowHeight(index),
                    tooltip: 'Reset to default',
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

