import 'package:flutter/material.dart';
import 'cells_controller.dart';

/// Widget hiển thị các nút điều khiển selection (Save, Delete, Clear)
class CellsSelectionButtons extends StatelessWidget {
  /// Controller để quản lý cells
  final CellsController controller;

  /// Callback khi nhấn nút Save
  final void Function(List<int> selectedIndices)? onSave;

  /// Callback khi nhấn nút Delete
  final void Function(List<int> selectedIndices)? onDelete;

  /// Callback khi nhấn nút Clear
  final VoidCallback? onClear;

  /// Màu nền nút Save
  final Color? saveButtonColor;

  /// Màu nền nút Delete
  final Color? deleteButtonColor;

  /// Màu nền nút Clear
  final Color? clearButtonColor;

  /// Hiển thị số lượng cells được chọn
  final bool showSelectionCount;

  const CellsSelectionButtons({
    super.key,
    required this.controller,
    this.onSave,
    this.onDelete,
    this.onClear,
    this.saveButtonColor,
    this.deleteButtonColor,
    this.clearButtonColor,
    this.showSelectionCount = true,
  });

  void _handleSave() {
    try {
      final selectedIndices = controller.getSelectedIndices();
      try {
        onSave?.call(selectedIndices);
      } catch (e) {
        // Ignore lỗi từ callback để tránh crash
      }
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  void _handleDelete() {
    try {
      final selectedIndices = controller.getSelectedIndices();
      try {
        onDelete?.call(selectedIndices);
      } catch (e) {
        // Ignore lỗi từ callback để tránh crash
      }
      controller.deleteSelectedCells();
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  void _handleClear() {
    try {
      controller.clearSelection();
      try {
        onClear?.call();
      } catch (e) {
        // Ignore lỗi từ callback để tránh crash
      }
    } catch (e) {
      // Ignore error để tránh crash
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      final selectedCount = controller.selectedCellsCount;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showSelectionCount)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Builder(
                builder: (context) {
                  try {
                    return Text(
                      'Đã chọn: $selectedCount cells',
                      style: Theme.of(context).textTheme.bodyMedium,
                    );
                  } catch (e) {
                    return const Text('Đã chọn: 0 cells');
                  }
                },
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: selectedCount > 0 ? _handleSave : null,
                  icon: const Icon(Icons.check, size: 20),
                  label: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: saveButtonColor ?? Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: selectedCount > 0 ? _handleDelete : null,
                  icon: const Icon(Icons.delete, size: 20),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deleteButtonColor ?? Colors.black87,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: selectedCount > 0 ? _handleClear : null,
                  icon: const Icon(Icons.clear, size: 20),
                  label: const Text('Clear'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: clearButtonColor ?? Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } catch (e) {
      // Fallback widget nếu có lỗi
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Text('Lỗi khi hiển thị nút điều khiển'),
      );
    }
  }
}
