import 'package:flutter/material.dart';
import 'cells_controller.dart';

/// Widget hiển thị grid cells với khả năng tùy chỉnh kích thước màn hình và số lượng cells
class CellsWidget extends StatefulWidget {
  /// Controller để quản lý trạng thái
  final CellsController? controller;

  /// Chiều rộng màn hình
  final double? screenWidth;

  /// Chiều cao màn hình
  final double? screenHeight;

  /// Số hàng cells
  final int? cellsRows;

  /// Số cột cells
  final int? cellsColumns;

  /// Màu border của cells
  final Color? borderColor;

  /// Độ dày border
  final double? borderWidth;

  /// Màu nền của cells
  final Color? cellColor;

  /// Callback khi cell được chọn
  final void Function(int row, int column)? onCellTap;

  /// Cho phép hiển thị số thứ tự cell
  final bool showCellNumbers;

  /// Màu chữ số thứ tự
  final Color? numberColor;

  /// Kích thước chữ số thứ tự
  final double? numberFontSize;

  /// Cho phép chọn cells (tap và drag)
  final bool enableSelection;

  /// Màu của cells được chọn
  final Color? selectedCellColor;

  /// Callback khi selection thay đổi (trả về danh sách index)
  final void Function(List<int> selectedIndices)? onSelectionChanged;

  /// Callback khi save selection (trả về danh sách index)
  final void Function(List<int> selectedIndices)? onSaveSelection;

  const CellsWidget({
    super.key,
    this.controller,
    this.screenWidth,
    this.screenHeight,
    this.cellsRows,
    this.cellsColumns,
    this.borderColor,
    this.borderWidth,
    this.cellColor,
    this.onCellTap,
    this.showCellNumbers = false,
    this.numberColor,
    this.numberFontSize,
    this.enableSelection = false,
    this.selectedCellColor,
    this.onSelectionChanged,
    this.onSaveSelection,
  }) : assert(
         controller != null ||
             (screenWidth != null &&
                 screenHeight != null &&
                 cellsRows != null &&
                 cellsColumns != null),
         'Phải cung cấp controller hoặc tất cả các tham số screenWidth, screenHeight, cellsRows, cellsColumns',
       );

  @override
  State<CellsWidget> createState() => _CellsWidgetState();
}

class _CellsWidgetState extends State<CellsWidget> {
  late CellsController _controller;
  bool _isInternalController = false;
  int? _dragStartIndex;
  bool _isDragging = false;
  bool _dragSelectMode = true; // true = chọn, false = bỏ chọn
  Set<int> _lastProcessedRange =
      {}; // Lưu range đã xử lý để tránh toggle nhiều lần
  final GlobalKey _gridKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    try {
      if (widget.controller != null) {
        _controller = widget.controller!;
      } else {
        // Assert đã đảm bảo các giá trị này không null
        _controller = CellsController(
          screenWidth: widget.screenWidth!,
          screenHeight: widget.screenHeight!,
          cellsRows: widget.cellsRows!,
          cellsColumns: widget.cellsColumns!,
        );
        _isInternalController = true;
      }
      _controller.addListener(_onControllerChanged);
    } catch (e) {
      // Fallback với giá trị mặc định nếu có lỗi
      _controller = CellsController(
        screenWidth: 600.0,
        screenHeight: 400.0,
        cellsRows: 10,
        cellsColumns: 10,
      );
      _isInternalController = true;
    }
  }

  @override
  void dispose() {
    try {
      _controller.removeListener(_onControllerChanged);
      if (_isInternalController) {
        _controller.dispose();
      }
    } catch (e) {
      // Ignore error khi dispose
    }
    super.dispose();
  }

  void _onControllerChanged() {
    try {
      if (mounted) {
        setState(() {});
        // Gọi callback khi selection thay đổi
        if (widget.enableSelection && widget.onSelectionChanged != null) {
          try {
            widget.onSelectionChanged!(_controller.getSelectedIndices());
          } catch (e) {
            // Ignore lỗi từ callback để tránh crash
          }
        }
      }
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  void _onCellTap(int index) {
    try {
      if (widget.enableSelection) {
        if (_controller.isCellSelected(index)) {
          _controller.deselectCell(index);
        } else {
          _controller.selectCell(index);
        }
      } else {
        try {
          final row = index ~/ _controller.cellsColumns;
          final column = index % _controller.cellsColumns;
          widget.onCellTap?.call(row, column);
        } catch (e) {
          // Ignore lỗi từ callback để tránh crash
        }
      }
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  void _onPanStart(DragStartDetails details, int index) {
    try {
      if (widget.enableSelection && index >= 0) {
        _dragStartIndex = index;
        _isDragging = true;
        _lastProcessedRange.clear();
        // Xác định mode dựa vào trạng thái của cell bắt đầu
        // Nếu cell đã chọn → mode bỏ chọn, nếu chưa chọn → mode chọn
        _dragSelectMode = !_controller.isCellSelected(index);

        // Xử lý cell bắt đầu ngay lập tức
        if (_dragSelectMode) {
          _controller.selectCell(index);
        } else {
          _controller.deselectCell(index);
        }
        _lastProcessedRange.add(index);
      }
    } catch (e) {
      // Ignore error để tránh crash
      _isDragging = false;
      _dragStartIndex = null;
    }
  }

  int _getCellIndexFromPosition(Offset localPosition) {
    try {
      final cellWidth = _controller.cellWidth;
      final cellHeight = _controller.cellHeight;

      // Kiểm tra để tránh chia cho 0
      if (cellWidth <= 0 || cellHeight <= 0) return -1;

      final column = (localPosition.dx / cellWidth).floor();
      final row = (localPosition.dy / cellHeight).floor();
      final index = row * _controller.cellsColumns + column;

      // Đảm bảo index trong phạm vi hợp lệ
      if (index >= 0 && index < _controller.totalCells) {
        return index;
      }
      return -1;
    } catch (e) {
      return -1;
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    try {
      if (widget.enableSelection && _isDragging && _dragStartIndex != null) {
        final RenderBox? renderBox =
            _gridKey.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          try {
            final localPosition = renderBox.globalToLocal(
              details.globalPosition,
            );
            final currentIndex = _getCellIndexFromPosition(localPosition);
            if (currentIndex >= 0 && _dragStartIndex != null) {
              // Tính toán range từ start đến current
              final start =
                  _dragStartIndex! < currentIndex
                      ? _dragStartIndex!
                      : currentIndex;
              final end =
                  _dragStartIndex! > currentIndex
                      ? _dragStartIndex!
                      : currentIndex;

              // Chỉ xử lý các cells chưa được xử lý trong lần drag này
              for (int i = start; i <= end; i++) {
                if (!_lastProcessedRange.contains(i)) {
                  if (_dragSelectMode) {
                    // Mode chọn: chọn cell nếu chưa chọn
                    if (!_controller.isCellSelected(i)) {
                      _controller.selectCell(i);
                    }
                  } else {
                    // Mode bỏ chọn: bỏ chọn cell nếu đã chọn
                    if (_controller.isCellSelected(i)) {
                      _controller.deselectCell(i);
                    }
                  }
                  _lastProcessedRange.add(i);
                }
              }
            }
          } catch (e) {
            // Ignore error khi tính toán position
          }
        }
      }
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  void _onPanEnd(DragEndDetails details) {
    _isDragging = false;
    _dragStartIndex = null;
    _lastProcessedRange.clear();
  }

  @override
  Widget build(BuildContext context) {
    try {
      final cellWidth = _controller.cellWidth;
      final cellHeight = _controller.cellHeight;
      final borderColor = widget.borderColor ?? Colors.grey;
      final borderWidth = widget.borderWidth ?? 1.0;
      final cellColor = widget.cellColor ?? Colors.transparent;
      final selectedColor =
          widget.selectedCellColor ?? Colors.red.withOpacity(0.5);
      final numberColor = widget.numberColor ?? Colors.black;
      final numberFontSize = widget.numberFontSize ?? 12.0;

      // Đảm bảo childAspectRatio hợp lệ (tránh chia cho 0)
      final aspectRatio = cellHeight > 0 ? cellWidth / cellHeight : 1.0;
      final totalCells = _controller.totalCells;
      final crossAxisCount =
          _controller.cellsColumns > 0 ? _controller.cellsColumns : 1;

      return GestureDetector(
        onPanStart:
            widget.enableSelection
                ? (details) {
                  try {
                    final RenderBox? renderBox =
                        context.findRenderObject() as RenderBox?;
                    if (renderBox != null) {
                      final localPosition = renderBox.globalToLocal(
                        details.globalPosition,
                      );
                      final index = _getCellIndexFromPosition(localPosition);
                      if (index >= 0) {
                        _onPanStart(details, index);
                      }
                    }
                  } catch (e) {
                    // Ignore error để tránh crash
                  }
                }
                : null,
        onPanUpdate: widget.enableSelection ? _onPanUpdate : null,
        onPanEnd: widget.enableSelection ? _onPanEnd : null,
        child: Container(
          key: _gridKey,
          width: _controller.screenWidth > 0 ? _controller.screenWidth : 600.0,
          height:
              _controller.screenHeight > 0 ? _controller.screenHeight : 400.0,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child:
              totalCells > 0
                  ? GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: aspectRatio,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                    ),
                    itemCount: totalCells,
                    itemBuilder: (context, index) {
                      try {
                        final isSelected =
                            widget.enableSelection &&
                            _controller.isCellSelected(index);
                        final backgroundColor =
                            isSelected ? selectedColor : cellColor;

                        return GestureDetector(
                          onTap: () => _onCellTap(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              border: Border.all(
                                color: borderColor,
                                width: borderWidth,
                              ),
                            ),
                            child:
                                widget.showCellNumbers
                                    ? Center(
                                      child: Text(
                                        '$index',
                                        style: TextStyle(
                                          color:
                                              isSelected
                                                  ? Colors.white
                                                  : numberColor,
                                          fontSize: numberFontSize,
                                          fontWeight:
                                              isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                        ),
                                      ),
                                    )
                                    : null,
                          ),
                        );
                      } catch (e) {
                        // Fallback widget nếu có lỗi
                        return Container(
                          decoration: BoxDecoration(
                            color: cellColor,
                            border: Border.all(
                              color: borderColor,
                              width: borderWidth,
                            ),
                          ),
                        );
                      }
                    },
                  )
                  : const SizedBox.shrink(),
        ),
      );
    } catch (e) {
      // Fallback widget nếu có lỗi nghiêm trọng
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Text('Lỗi khi hiển thị grid cells'),
      );
    }
  }
}

/// Widget để nhập và hiển thị thông tin cells với form input
class CellsInputWidget extends StatefulWidget {
  /// Controller để quản lý
  final CellsController? controller;

  /// Callback khi giá trị thay đổi
  final void Function(double width, double height, int rows, int columns)?
  onChanged;

  /// Hiển thị widget cells bên dưới form
  final bool showCellsPreview;

  const CellsInputWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.showCellsPreview = true,
  });

  @override
  State<CellsInputWidget> createState() => _CellsInputWidgetState();
}

class _CellsInputWidgetState extends State<CellsInputWidget> {
  late TextEditingController _widthController;
  late TextEditingController _heightController;
  late TextEditingController _rowsController;
  late TextEditingController _columnsController;
  late CellsController _cellsController;
  bool _isInternalController = false;

  @override
  void initState() {
    super.initState();
    try {
      if (widget.controller != null) {
        _cellsController = widget.controller!;
      } else {
        // Tạo controller với giá trị mặc định cho CellsInputWidget
        _cellsController = CellsController(
          screenWidth: 2048.0,
          screenHeight: 500.0,
          cellsRows: 32,
          cellsColumns: 23,
        );
        _isInternalController = true;
      }

      _widthController = TextEditingController(
        text: _cellsController.screenWidth.toStringAsFixed(0),
      );
      _heightController = TextEditingController(
        text: _cellsController.screenHeight.toStringAsFixed(0),
      );
      _rowsController = TextEditingController(
        text: _cellsController.cellsRows.toString(),
      );
      _columnsController = TextEditingController(
        text: _cellsController.cellsColumns.toString(),
      );

      _cellsController.addListener(_updateControllers);
    } catch (e) {
      // Fallback với giá trị mặc định
      _cellsController = CellsController(
        screenWidth: 2048.0,
        screenHeight: 500.0,
        cellsRows: 32,
        cellsColumns: 23,
      );
      _isInternalController = true;
      _widthController = TextEditingController(text: '2048');
      _heightController = TextEditingController(text: '500');
      _rowsController = TextEditingController(text: '32');
      _columnsController = TextEditingController(text: '23');
    }
  }

  @override
  void dispose() {
    try {
      _cellsController.removeListener(_updateControllers);
      _widthController.dispose();
      _heightController.dispose();
      _rowsController.dispose();
      _columnsController.dispose();
      if (_isInternalController) {
        _cellsController.dispose();
      }
    } catch (e) {
      // Ignore error khi dispose
    }
    super.dispose();
  }

  void _updateControllers() {
    try {
      if (mounted) {
        _widthController.text = _cellsController.screenWidth.toStringAsFixed(0);
        _heightController.text = _cellsController.screenHeight.toStringAsFixed(
          0,
        );
        _rowsController.text = _cellsController.cellsRows.toString();
        _columnsController.text = _cellsController.cellsColumns.toString();
        setState(() {});
      }
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  void _onValueChanged() {
    try {
      final width = double.tryParse(_widthController.text) ?? 0;
      final height = double.tryParse(_heightController.text) ?? 0;
      final rows = int.tryParse(_rowsController.text) ?? 0;
      final columns = int.tryParse(_columnsController.text) ?? 0;

      if (width > 0 && height > 0 && rows > 0 && columns > 0) {
        _cellsController.screenWidth = width;
        _cellsController.screenHeight = height;
        _cellsController.cellsRows = rows;
        _cellsController.cellsColumns = columns;

        try {
          widget.onChanged?.call(width, height, rows, columns);
        } catch (e) {
          // Ignore lỗi từ callback để tránh crash
        }
      }
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _widthController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Chiều rộng màn hình',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _onValueChanged(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Chiều cao màn hình',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _onValueChanged(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _rowsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Số hàng cells',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _onValueChanged(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _columnsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Số cột cells',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _onValueChanged(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Builder(
            builder: (context) {
              try {
                return Text(
                  'Kích thước mỗi cell: ${_cellsController.cellWidth.toStringAsFixed(2)} x ${_cellsController.cellHeight.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                );
              } catch (e) {
                return const Text('Kích thước mỗi cell: Tính toán...');
              }
            },
          ),
          if (widget.showCellsPreview) ...[
            const SizedBox(height: 16),
            Builder(
              builder: (context) {
                try {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: CellsWidget(
                        controller: _cellsController,
                        borderColor: Colors.blue,
                        borderWidth: 0.5,
                        cellColor: Colors.grey.withOpacity(0.1),
                      ),
                    ),
                  );
                } catch (e) {
                  return const SizedBox(
                    height: 100,
                    child: Center(child: Text('Lỗi khi hiển thị preview')),
                  );
                }
              },
            ),
          ],
        ],
      );
    } catch (e) {
      // Fallback widget nếu có lỗi
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Text('Lỗi khi hiển thị form nhập'),
      );
    }
  }
}
