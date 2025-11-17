import 'package:flutter/material.dart';
import 'cells_controller.dart';

/// Chế độ kéo chọn cells
enum DragSelectionMode {
  /// Kéo chọn từng ô (chỉ chọn ô hiện tại đang kéo qua)
  singleCell,

  /// Kéo chọn nhiều ô (chọn tất cả ô trong hình chữ nhật)
  multipleCells,
}

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

  /// Chế độ kéo chọn cells (singleCell: chọn từng ô, multipleCells: chọn nhiều ô)
  /// Mặc định: multipleCells (chọn nhiều ô trong hình chữ nhật)
  final DragSelectionMode dragSelectionMode;

  /// Màu của cells được chọn
  final Color? selectedCellColor;

  /// Màu của cells chưa được chọn (ưu tiên hơn cellColor khi enableSelection = true)
  final Color? unselectedCellColor;

  /// Map màu theo hàng (row index -> Color)
  /// Cho phép tùy chỉnh màu cho từng hàng
  final Map<int, Color>? rowColors;

  /// Map màu theo cột (column index -> Color)
  /// Cho phép tùy chỉnh màu cho từng cột
  final Map<int, Color>? columnColors;

  /// Callback khi selection thay đổi (trả về danh sách index)
  final void Function(List<int> selectedIndices)? onSelectionChanged;

  /// Callback khi save selection (trả về danh sách index)
  final void Function(List<int> selectedIndices)? onSaveSelection;

  /// Danh sách cells được chọn ban đầu (ví dụ dữ liệu từ server)
  final List<int>? initialSelectedCells;

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
    this.dragSelectionMode = DragSelectionMode.multipleCells,
    this.selectedCellColor,
    this.unselectedCellColor,
    this.rowColors,
    this.columnColors,
    this.onSelectionChanged,
    this.onSaveSelection,
    this.initialSelectedCells,
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
  final Set<int> _lastProcessedRange =
      <int>{}; // Lưu range đã xử lý để tránh toggle nhiều lần
  final GlobalKey _gridKey = GlobalKey();
  final Map<int, GlobalKey> _cellKeys =
      {}; // Map index -> GlobalKey cho mỗi cell
  Offset? _pointerDownPosition;
  bool _initialSelectionApplied = false;

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
    _applyInitialSelection();
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

  void _applyInitialSelection() {
    try {
      if (!_initialSelectionApplied &&
          widget.initialSelectedCells != null &&
          widget.initialSelectedCells!.isNotEmpty) {
        _controller.setSelectedCells(widget.initialSelectedCells!);
        _initialSelectionApplied = true;
      }
    } catch (e) {
      // Ignore error
    }
  }

  @override
  void didUpdateWidget(covariant CellsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    try {
      if (widget.initialSelectedCells != oldWidget.initialSelectedCells) {
        _initialSelectionApplied = false;
        _applyInitialSelection();
      }
    } catch (e) {
      // Ignore error
    }
  }

  int? _getCellIndexFromHitTest(Offset globalPosition) {
    try {
      // Sử dụng HitTest để tìm widget nào đang được touch
      final RenderBox? containerBox =
          _gridKey.currentContext?.findRenderObject() as RenderBox?;
      if (containerBox == null) return null;

      // Kiểm tra xem vị trí có nằm trong Container không
      final localPosition = containerBox.globalToLocal(globalPosition);
      if (!containerBox.size.contains(localPosition)) {
        return null;
      }

      // Duyệt qua tất cả các cell keys để tìm cell nào chứa vị trí này
      for (final entry in _cellKeys.entries) {
        final cellKey = entry.value;
        final cellIndex = entry.key;
        final cellContext = cellKey.currentContext;

        if (cellContext != null) {
          final cellBox = cellContext.findRenderObject() as RenderBox?;
          if (cellBox != null) {
            // Chuyển đổi global position sang local position của cell
            try {
              final cellLocalPosition = cellBox.globalToLocal(globalPosition);
              // Kiểm tra xem vị trí có nằm trong bounds của cell không
              if (cellBox.size.contains(cellLocalPosition)) {
                return cellIndex;
              }
            } catch (e) {
              // Ignore error khi convert position
            }
          }
        }
      }
    } catch (e) {
      // Ignore error
    }
    return null;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    try {
      if (widget.enableSelection && _isDragging && _dragStartIndex != null) {
        final currentIndex = _getCellIndexFromHitTest(details.globalPosition);
        if (currentIndex != null &&
            currentIndex >= 0 &&
            _dragStartIndex != null) {
          if (widget.dragSelectionMode == DragSelectionMode.singleCell) {
            // Chế độ kéo chọn từng ô: chỉ chọn ô hiện tại đang kéo qua
            if (!_lastProcessedRange.contains(currentIndex)) {
              if (_dragSelectMode) {
                // Mode chọn: chọn cell nếu chưa chọn
                if (!_controller.isCellSelected(currentIndex)) {
                  _controller.selectCell(currentIndex);
                }
              } else {
                // Mode bỏ chọn: bỏ chọn cell nếu đã chọn
                if (_controller.isCellSelected(currentIndex)) {
                  _controller.deselectCell(currentIndex);
                }
              }
              _lastProcessedRange.add(currentIndex);
            }
          } else {
            // Chế độ kéo chọn nhiều ô: chọn tất cả ô trong hình chữ nhật
            // Tính toán range từ start đến current (bao gồm cả hàng và cột)
            // Chuyển đổi index sang row và column để chọn hình chữ nhật
            final startRow = _dragStartIndex! ~/ _controller.cellsColumns;
            final startCol = _dragStartIndex! % _controller.cellsColumns;
            final currentRow = currentIndex ~/ _controller.cellsColumns;
            final currentCol = currentIndex % _controller.cellsColumns;

            final minRow = startRow < currentRow ? startRow : currentRow;
            final maxRow = startRow > currentRow ? startRow : currentRow;
            final minCol = startCol < currentCol ? startCol : currentCol;
            final maxCol = startCol > currentCol ? startCol : currentCol;

            // Chọn tất cả cells trong hình chữ nhật
            for (int row = minRow; row <= maxRow; row++) {
              for (int col = minCol; col <= maxCol; col++) {
                final i = row * _controller.cellsColumns + col;
                if (i >= 0 &&
                    i < _controller.totalCells &&
                    !_lastProcessedRange.contains(i)) {
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
      final defaultCellColor = widget.cellColor ?? Colors.transparent;
      final unselectedColor = widget.unselectedCellColor ?? defaultCellColor;
      final selectedColor =
          widget.selectedCellColor ?? Colors.red.withValues(alpha: 0.5);
      final numberColor = widget.numberColor ?? Colors.black;
      final numberFontSize = widget.numberFontSize ?? 12.0;

      // Đảm bảo childAspectRatio hợp lệ (tránh chia cho 0)
      final aspectRatio = cellHeight > 0 ? cellWidth / cellHeight : 1.0;
      final totalCells = _controller.totalCells;
      final crossAxisCount =
          _controller.cellsColumns > 0 ? _controller.cellsColumns : 1;

      return Listener(
        onPointerDown:
            widget.enableSelection
                ? (event) {
                  try {
                    _pointerDownPosition = event.position;
                    final index = _getCellIndexFromHitTest(event.position);
                    if (index != null && index >= 0) {
                      _dragStartIndex = index;
                    }
                  } catch (e) {
                    // Ignore error
                  }
                }
                : null,
        onPointerMove:
            widget.enableSelection
                ? (event) {
                  try {
                    // Nếu có movement đáng kể, bắt đầu drag
                    if (_pointerDownPosition != null &&
                        _dragStartIndex != null) {
                      final distance =
                          (event.position - _pointerDownPosition!).distance;
                      if (distance > 5.0) {
                        // Có movement, bắt đầu drag
                        if (!_isDragging) {
                          _isDragging = true;
                          _lastProcessedRange.clear();
                          // Xác định mode dựa vào trạng thái của cell bắt đầu
                          _dragSelectMode =
                              !_controller.isCellSelected(_dragStartIndex!);
                          // Xử lý cell bắt đầu ngay lập tức
                          if (_dragSelectMode) {
                            _controller.selectCell(_dragStartIndex!);
                          } else {
                            _controller.deselectCell(_dragStartIndex!);
                          }
                          _lastProcessedRange.add(_dragStartIndex!);
                        }
                        // Tiếp tục drag
                        final index = _getCellIndexFromHitTest(event.position);
                        if (index != null && index >= 0) {
                          _onPanUpdate(
                            DragUpdateDetails(globalPosition: event.position),
                          );
                        }
                      }
                    }
                  } catch (e) {
                    // Ignore error
                  }
                }
                : null,
        onPointerUp:
            widget.enableSelection
                ? (event) {
                  try {
                    if (_isDragging) {
                      // Đang drag, kết thúc drag
                      _onPanEnd(DragEndDetails());
                    } else if (_dragStartIndex != null) {
                      // Không có drag, đây là tap đơn giản - xử lý ngay
                      _onCellTap(_dragStartIndex!);
                    }
                    // Reset
                    _pointerDownPosition = null;
                    _dragStartIndex = null;
                    _isDragging = false;
                  } catch (e) {
                    // Ignore error
                  }
                }
                : null,
        onPointerCancel:
            widget.enableSelection
                ? (event) {
                  try {
                    if (_isDragging) {
                      _onPanEnd(DragEndDetails());
                    }
                    // Reset
                    _pointerDownPosition = null;
                    _dragStartIndex = null;
                    _isDragging = false;
                  } catch (e) {
                    // Ignore error
                  }
                }
                : null,
        behavior: HitTestBehavior.translucent,
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
                        // Tạo hoặc lấy GlobalKey cho cell này
                        if (!_cellKeys.containsKey(index)) {
                          _cellKeys[index] = GlobalKey();
                        }
                        final cellKey = _cellKeys[index]!;

                        final isSelected =
                            widget.enableSelection &&
                            _controller.isCellSelected(index);

                        // Tính toán màu nền theo thứ tự ưu tiên:
                        // 1. Nếu cell được chọn → dùng selectedCellColor
                        // 2. Nếu có màu theo hàng → dùng rowColor
                        // 3. Nếu có màu theo cột → dùng columnColor
                        // 4. Nếu không → dùng unselectedCellColor hoặc cellColor
                        Color backgroundColor;
                        if (isSelected) {
                          backgroundColor = selectedColor;
                        } else {
                          // Tính row và column từ index
                          final row = index ~/ _controller.cellsColumns;
                          final column = index % _controller.cellsColumns;

                          // Kiểm tra màu theo hàng trước
                          if (widget.rowColors != null &&
                              widget.rowColors!.containsKey(row)) {
                            backgroundColor = widget.rowColors![row]!;
                          }
                          // Sau đó kiểm tra màu theo cột
                          else if (widget.columnColors != null &&
                              widget.columnColors!.containsKey(column)) {
                            backgroundColor = widget.columnColors![column]!;
                          }
                          // Cuối cùng dùng màu mặc định
                          else {
                            backgroundColor = unselectedColor;
                          }
                        }

                        return Container(
                          key: cellKey,
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
                        );
                      } catch (e) {
                        // Fallback widget nếu có lỗi
                        return Container(
                          decoration: BoxDecoration(
                            color: unselectedColor,
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
                        cellColor: Colors.grey.withValues(alpha: 0.1),
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
