import 'package:flutter/material.dart';
import 'cells_controller.dart';
import 'cells_data_controller.dart';
import 'cells_size_controller.dart';

/// Widget hiển thị cells với dữ liệu có thể edit (như Excel)
class CellsDataWidget extends StatefulWidget {
  /// CellsController để quản lý grid
  final CellsController controller;
  
  /// CellsDataController để quản lý dữ liệu
  final CellsDataController? dataController;
  
  /// CellsSizeController để quản lý kích thước tùy chỉnh
  final CellsSizeController? sizeController;
  
  /// Cho phép edit cells
  final bool enableEdit;
  
  /// Màu border
  final Color? borderColor;
  
  /// Độ dày border
  final double? borderWidth;
  
  /// Màu nền mặc định
  final Color? defaultCellColor;
  
  /// Màu border của cell đang được edit
  final Color? editingCellBorderColor;
  
  /// Callback khi cell text thay đổi
  final void Function(int index, String text)? onCellTextChanged;
  
  /// Callback khi cell được tap
  final void Function(int index)? onCellTap;
  
  /// Hiển thị header row (hàng đầu tiên)
  final bool showHeader;
  
  /// Header row background color
  final Color? headerBackgroundColor;
  
  /// Header text style
  final TextStyle? headerTextStyle;

  const CellsDataWidget({
    super.key,
    required this.controller,
    this.dataController,
    this.sizeController,
    this.enableEdit = false,
    this.borderColor,
    this.borderWidth,
    this.defaultCellColor,
    this.editingCellBorderColor,
    this.onCellTextChanged,
    this.onCellTap,
    this.showHeader = false,
    this.headerBackgroundColor,
    this.headerTextStyle,
  });

  @override
  State<CellsDataWidget> createState() => _CellsDataWidgetState();
}

class _CellsDataWidgetState extends State<CellsDataWidget> {
  late CellsDataController _dataController;
  bool _isInternalDataController = false;
  CellsSizeController? _sizeController;
  bool _isInternalSizeController = false;
  int? _editingCellIndex;
  final Map<int, TextEditingController> _textControllers = {};
  final Map<int, FocusNode> _focusNodes = {};

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
      _dataController.addListener(_onDataChanged);
      
      // Khởi tạo size controller nếu có
      if (widget.sizeController != null) {
        _sizeController = widget.sizeController!;
      } else {
        _sizeController = CellsSizeController(widget.controller);
        _isInternalSizeController = true;
      }
      _sizeController?.addListener(_onDataChanged);
    } catch (e) {
      _dataController = CellsDataController(widget.controller);
      _isInternalDataController = true;
      _sizeController = CellsSizeController(widget.controller);
      _isInternalSizeController = true;
    }
  }

  @override
  void dispose() {
    try {
      _dataController.removeListener(_onDataChanged);
      _sizeController?.removeListener(_onDataChanged);
      for (final controller in _textControllers.values) {
        controller.dispose();
      }
      for (final focusNode in _focusNodes.values) {
        focusNode.dispose();
      }
      if (_isInternalDataController) {
        _dataController.dispose();
      }
      if (_isInternalSizeController) {
        _sizeController?.dispose();
      }
    } catch (e) {
      // Ignore error
    }
    super.dispose();
  }

  void _onDataChanged() {
    try {
      if (mounted) {
        // Cập nhật TextEditingController nếu cell không đang được edit
        for (final entry in _textControllers.entries) {
          final index = entry.key;
          final controller = entry.value;
          if (index != _editingCellIndex) {
            final newText = _dataController.getCellText(index);
            if (controller.text != newText) {
              controller.text = newText;
            }
          }
        }
        setState(() {});
      }
    } catch (e) {
      // Ignore error
    }
  }

  TextEditingController _getTextController(int index) {
    if (!_textControllers.containsKey(index)) {
      final text = _dataController.getCellText(index);
      _textControllers[index] = TextEditingController(text: text);
    } else {
      // Cập nhật text nếu không đang edit
      if (index != _editingCellIndex) {
        final newText = _dataController.getCellText(index);
        if (_textControllers[index]!.text != newText) {
          _textControllers[index]!.text = newText;
        }
      }
    }
    return _textControllers[index]!;
  }

  FocusNode _getFocusNode(int index) {
    if (!_focusNodes.containsKey(index)) {
      _focusNodes[index] = FocusNode();
    }
    return _focusNodes[index]!;
  }

  void _onCellTap(int index) {
    try {
      widget.onCellTap?.call(index);
      if (widget.enableEdit) {
        setState(() {
          _editingCellIndex = index;
        });
        // Focus vào cell để edit
        Future.delayed(const Duration(milliseconds: 100), () {
          _getFocusNode(index).requestFocus();
        });
      }
    } catch (e) {
      // Ignore error
    }
  }

  void _onCellTextChanged(int index, String text) {
    try {
      _dataController.setCellText(index, text);
      widget.onCellTextChanged?.call(index, text);
    } catch (e) {
      // Ignore error
    }
  }

  void _onCellEditingComplete(int index) {
    try {
      final controller = _textControllers[index];
      if (controller != null) {
        _onCellTextChanged(index, controller.text);
      }
      setState(() {
        _editingCellIndex = null;
      });
    } catch (e) {
      // Ignore error
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      // Kiểm tra xem có sử dụng kích thước tùy chỉnh không
      final useCustomSizes = _sizeController != null && 
          _sizeController!.enableCustomSizes;
      
      if (useCustomSizes) {
        return _buildTableWithCustomSizes();
      } else {
        return _buildGridView();
      }
    } catch (e) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Text('Error displaying cells data'),
      );
    }
  }

  Widget _buildTableWithCustomSizes() {
    try {
      final borderColor = widget.borderColor ?? Colors.grey;
      final borderWidth = widget.borderWidth ?? 1.0;
      final defaultCellColor = widget.defaultCellColor ?? Colors.white;
      final editingBorderColor = widget.editingCellBorderColor ?? Colors.blue;
      
      // Tạo danh sách column widths
      final columnWidths = <int, TableColumnWidth>{};
      for (int col = 0; col < widget.controller.cellsColumns; col++) {
        final width = _sizeController!.getColumnActualWidth(col);
        columnWidths[col] = FixedColumnWidth(width);
      }
      
      // Tạo danh sách rows
      final rows = <TableRow>[];
      for (int row = 0; row < widget.controller.cellsRows; row++) {
        final rowHeight = _sizeController!.getRowActualHeight(row);
        final cells = <Widget>[];
        
        for (int col = 0; col < widget.controller.cellsColumns; col++) {
          final index = row * widget.controller.cellsColumns + col;
          // Wrap cell trong ConstrainedBox để đặt chiều cao
          cells.add(ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: rowHeight,
              maxHeight: rowHeight,
            ),
            child: _buildCell(index, borderColor, borderWidth, defaultCellColor, editingBorderColor, rowHeight),
          ));
        }
        
        rows.add(TableRow(
          children: cells,
        ));
      }
      
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: Table(
              border: TableBorder.all(
                color: borderColor,
                width: borderWidth,
              ),
              columnWidths: columnWidths,
              children: rows,
            ),
          ),
        ),
      );
    } catch (e) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Text('Error building table with custom sizes'),
      );
    }
  }

  Widget _buildCell(int index, Color borderColor, double borderWidth, 
      Color defaultCellColor, Color editingBorderColor, double? cellHeight) {
    try {
      final isEditing = widget.enableEdit && _editingCellIndex == index;
      final cellData = _dataController.getCellData(index);
      final text = _dataController.getCellText(index);
      final isHeader = widget.showHeader && index < widget.controller.cellsColumns;
      
      final backgroundColor = cellData?.backgroundColor ??
          (isHeader
              ? (widget.headerBackgroundColor ?? Colors.grey[300])
              : defaultCellColor);
      final textColor = cellData?.textColor ?? Colors.black;
      final baseFontSize = cellData?.fontSize;
      double fontSize;
      if (baseFontSize != null) {
        fontSize = baseFontSize;
      } else {
        final cellWidth = _sizeController?.getColumnActualWidth(index % widget.controller.cellsColumns) ?? widget.controller.cellWidth;
        final minCellSize = cellWidth < (cellHeight ?? widget.controller.cellHeight) 
            ? cellWidth 
            : (cellHeight ?? widget.controller.cellHeight);
        fontSize = (minCellSize * 0.4).clamp(10.0, 14.0);
      }
      final fontWeight = cellData?.fontWeight ??
          (isHeader ? FontWeight.bold : FontWeight.normal);
      final textAlign = cellData?.textAlign ?? TextAlign.left;
      
      return GestureDetector(
        onTap: () => _onCellTap(index),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: isEditing ? editingBorderColor : Colors.transparent,
              width: isEditing ? 2.0 : 0,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
          child: isEditing
              ? TextField(
                  controller: _getTextController(index),
                  focusNode: _getFocusNode(index),
                  style: TextStyle(
                    color: textColor,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                  ),
                  textAlign: textAlign,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onEditingComplete: () => _onCellEditingComplete(index),
                  onSubmitted: (value) {
                    _onCellTextChanged(index, value);
                    _onCellEditingComplete(index);
                  },
                  onChanged: (value) {
                    _onCellTextChanged(index, value);
                  },
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final textPainter = TextPainter(
                      text: TextSpan(
                        text: text,
                        style: TextStyle(
                          color: textColor,
                          fontSize: fontSize,
                          fontWeight: fontWeight,
                        ),
                      ),
                      textAlign: textAlign,
                      maxLines: 1,
                      textDirection: TextDirection.ltr,
                    );
                    textPainter.layout(maxWidth: double.infinity);
                    
                    final textWidth = textPainter.size.width;
                    final availableWidth = constraints.maxWidth;
                    
                    if (textWidth <= availableWidth) {
                      return Tooltip(
                        message: text,
                        preferBelow: false,
                        child: Text(
                          text,
                          style: TextStyle(
                            color: textColor,
                            fontSize: fontSize,
                            fontWeight: fontWeight,
                          ),
                          textAlign: textAlign,
                          overflow: TextOverflow.visible,
                        ),
                      );
                    }
                    
                    return Tooltip(
                      message: text,
                      preferBelow: false,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: textAlign == TextAlign.center
                            ? Alignment.center
                            : textAlign == TextAlign.right
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Text(
                          text,
                          style: TextStyle(
                            color: textColor,
                            fontSize: fontSize,
                            fontWeight: fontWeight,
                          ),
                          textAlign: textAlign,
                          maxLines: 1,
                        ),
                      ),
                    );
                  },
                ),
        ),
      );
    } catch (e) {
      return Container(
        decoration: BoxDecoration(
          color: defaultCellColor,
          border: Border.all(color: borderColor, width: borderWidth),
        ),
      );
    }
  }

  Widget _buildGridView() {
    try {
      final cellWidth = widget.controller.cellWidth;
      final cellHeight = widget.controller.cellHeight;
      final borderColor = widget.borderColor ?? Colors.grey;
      final borderWidth = widget.borderWidth ?? 1.0;
      final defaultCellColor = widget.defaultCellColor ?? Colors.white;
      final editingBorderColor = widget.editingCellBorderColor ?? Colors.blue;
      final aspectRatio = cellHeight > 0 ? cellWidth / cellHeight : 1.0;
      final totalCells = widget.controller.totalCells;
      final crossAxisCount = widget.controller.cellsColumns > 0
          ? widget.controller.cellsColumns
          : 1;

      return Container(
        width: widget.controller.screenWidth > 0
            ? widget.controller.screenWidth
            : 600.0,
        height: widget.controller.screenHeight > 0
            ? widget.controller.screenHeight
            : 400.0,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: totalCells > 0
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
                    final isEditing = widget.enableEdit &&
                        _editingCellIndex == index;
                    final cellData = _dataController.getCellData(index);
                    final text = _dataController.getCellText(index);
                    final isHeader = widget.showHeader &&
                        index < widget.controller.cellsColumns;
                    
                    final backgroundColor = cellData?.backgroundColor ??
                        (isHeader
                            ? (widget.headerBackgroundColor ??
                                Colors.grey[300])
                            : defaultCellColor);
                    final textColor = cellData?.textColor ?? Colors.black;
                    // Tự động điều chỉnh font size dựa trên kích thước cell
                    final baseFontSize = cellData?.fontSize;
                    double fontSize;
                    if (baseFontSize != null) {
                      fontSize = baseFontSize;
                    } else {
                      // Tính toán font size phù hợp với kích thước cell
                      final minCellSize = cellWidth < cellHeight ? cellWidth : cellHeight;
                      // Font size = 40% của kích thước cell nhỏ nhất, nhưng không nhỏ hơn 10
                      fontSize = (minCellSize * 0.4).clamp(10.0, 14.0);
                    }
                    final fontWeight = cellData?.fontWeight ??
                        (isHeader ? FontWeight.bold : FontWeight.normal);
                    final textAlign = cellData?.textAlign ?? TextAlign.left;

                    return GestureDetector(
                      onTap: () => _onCellTap(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          border: Border.all(
                            color: isEditing
                                ? editingBorderColor
                                : borderColor,
                            width: isEditing ? 2.0 : borderWidth,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 4.0,
                        ),
                        child: isEditing
                            ? TextField(
                                controller: _getTextController(index),
                                focusNode: _getFocusNode(index),
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: fontSize,
                                  fontWeight: fontWeight,
                                ),
                                textAlign: textAlign,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onEditingComplete: () =>
                                    _onCellEditingComplete(index),
                                onSubmitted: (value) {
                                  _onCellTextChanged(index, value);
                                  _onCellEditingComplete(index);
                                },
                                onChanged: (value) {
                                  _onCellTextChanged(index, value);
                                },
                              )
                            : LayoutBuilder(
                                builder: (context, constraints) {
                                  // Đo chiều rộng text
                                  final textPainter = TextPainter(
                                    text: TextSpan(
                                      text: text,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: fontSize,
                                        fontWeight: fontWeight,
                                      ),
                                    ),
                                    textAlign: textAlign,
                                    maxLines: 1,
                                    textDirection: TextDirection.ltr,
                                  );
                                  textPainter.layout(maxWidth: double.infinity);
                                  
                                  final textWidth = textPainter.size.width;
                                  final availableWidth = constraints.maxWidth;
                                  
                                  // Nếu text vừa với cell, hiển thị bình thường
                                  if (textWidth <= availableWidth) {
                                    return Tooltip(
                                      message: text,
                                      preferBelow: false,
                                      child: Text(
                                        text,
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: fontSize,
                                          fontWeight: fontWeight,
                                        ),
                                        textAlign: textAlign,
                                        overflow: TextOverflow.visible,
                                      ),
                                    );
                                  }
                                  
                                  // Nếu text dài hơn, sử dụng FittedBox để scale
                                  return Tooltip(
                                    message: text,
                                    preferBelow: false,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: textAlign == TextAlign.center
                                          ? Alignment.center
                                          : textAlign == TextAlign.right
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                      child: Text(
                                        text,
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: fontSize,
                                          fontWeight: fontWeight,
                                        ),
                                        textAlign: textAlign,
                                        maxLines: 1,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    );
                  } catch (e) {
                    return Container(
                      decoration: BoxDecoration(
                        color: defaultCellColor,
                        border: Border.all(color: borderColor, width: borderWidth),
                      ),
                    );
                  }
                },
              )
            : const SizedBox.shrink(),
      );
    } catch (e) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Text('Error displaying cells data'),
      );
    }
  }
}

