import 'cells_data_controller.dart';
import 'cells_controller.dart';

/// Utilities cho CellsDataController (Search, Sort, Filter, Export/Import)

/// Tìm kiếm text trong cells
class CellsSearch {
  /// Tìm tất cả cells chứa text
  static List<int> searchCells(
    CellsDataController dataController,
    CellsController controller,
    String searchText, {
    bool caseSensitive = false,
    bool matchWholeWord = false,
  }) {
    try {
      final List<int> results = [];
      final searchLower = caseSensitive ? searchText : searchText.toLowerCase();
      
      for (int i = 0; i < controller.totalCells; i++) {
        final cellText = dataController.getCellText(i);
        
        if (cellText.isEmpty) continue;
        
        final cellLower = caseSensitive ? cellText : cellText.toLowerCase();
        
        bool matches = false;
        if (matchWholeWord) {
          matches = cellLower == searchLower;
        } else {
          matches = cellLower.contains(searchLower);
        }
        
        if (matches) {
          results.add(i);
        }
      }
      
      return results;
    } catch (e) {
      return [];
    }
  }

  /// Tìm và thay thế text
  static int replaceAll(
    CellsDataController dataController,
    CellsController controller,
    String searchText,
    String replaceText, {
    bool caseSensitive = false,
  }) {
    try {
      int count = 0;
      final searchLower = caseSensitive ? searchText : searchText.toLowerCase();
      
      for (int i = 0; i < controller.totalCells; i++) {
        final cellText = dataController.getCellText(i);
        final cellLower = caseSensitive ? cellText : cellText.toLowerCase();
        
        if (cellLower.contains(searchLower)) {
          final newText = cellText.replaceAll(
            caseSensitive ? searchText : RegExp(searchText, caseSensitive: false),
            replaceText,
          );
          dataController.setCellText(i, newText);
          count++;
        }
      }
      
      return count;
    } catch (e) {
      return 0;
    }
  }
}

/// Sắp xếp dữ liệu trong cells
class CellsSort {
  /// Sắp xếp theo cột
  static void sortByColumn(
    CellsDataController dataController,
    CellsController controller,
    int columnIndex, {
    bool ascending = true,
    int startRow = 0,
  }) {
    try {
      if (columnIndex < 0 || columnIndex >= controller.cellsColumns) return;
      if (startRow < 0 || startRow >= controller.cellsRows) return;

      // Lấy dữ liệu của cột
      final List<MapEntry<int, String>> columnData = [];
      for (int row = startRow; row < controller.cellsRows; row++) {
        final index = row * controller.cellsColumns + columnIndex;
        if (index < controller.totalCells) {
          columnData.add(MapEntry(index, dataController.getCellText(index)));
        }
      }

      // Sắp xếp
      columnData.sort((a, b) {
        final aText = a.value;
        final bText = b.value;
        
        // Thử parse số
        final aNum = double.tryParse(aText);
        final bNum = double.tryParse(bText);
        
        int compare;
        if (aNum != null && bNum != null) {
          compare = aNum.compareTo(bNum);
        } else {
          compare = aText.compareTo(bText);
        }
        
        return ascending ? compare : -compare;
      });

      // Lưu lại dữ liệu đã sắp xếp
      final List<String> sortedValues = columnData.map((e) => e.value).toList();
      for (int i = 0; i < sortedValues.length; i++) {
        final row = startRow + i;
        final index = row * controller.cellsColumns + columnIndex;
        if (index < controller.totalCells) {
          dataController.setCellText(index, sortedValues[i]);
        }
      }
    } catch (e) {
      // Ignore error
    }
  }

  /// Sắp xếp theo nhiều cột
  static void sortByMultipleColumns(
    CellsDataController dataController,
    CellsController controller,
    List<int> columnIndexes, {
    List<bool>? ascending,
    int startRow = 0,
  }) {
    try {
      if (columnIndexes.isEmpty) return;
      final ascList = ascending ?? List.filled(columnIndexes.length, true);
      
      // Sắp xếp từ cột cuối về đầu (stable sort)
      for (int i = columnIndexes.length - 1; i >= 0; i--) {
        sortByColumn(
          dataController,
          controller,
          columnIndexes[i],
          ascending: ascList[i],
          startRow: startRow,
        );
      }
    } catch (e) {
      // Ignore error
    }
  }
}

/// Lọc dữ liệu
class CellsFilter {
  /// Lọc các rows theo điều kiện
  static List<int> filterRows(
    CellsDataController dataController,
    CellsController controller,
    bool Function(List<String> rowData) filterFunction,
  ) {
    try {
      final List<int> matchingRows = [];
      
      for (int row = 0; row < controller.cellsRows; row++) {
        final List<String> rowData = [];
        for (int col = 0; col < controller.cellsColumns; col++) {
          final index = row * controller.cellsColumns + col;
          if (index < controller.totalCells) {
            rowData.add(dataController.getCellText(index));
          }
        }
        
        if (filterFunction(rowData)) {
          matchingRows.add(row);
        }
      }
      
      return matchingRows;
    } catch (e) {
      return [];
    }
  }
}

/// Export/Import utilities
class CellsExportImport {
  /// Export ra CSV string
  static String exportToCsv(
    CellsDataController dataController,
    CellsController controller,
  ) {
    try {
      final data = dataController.exportData();
      return data.map((row) => row.map((cell) => _escapeCsv(cell)).join(',')).join('\n');
    } catch (e) {
      return '';
    }
  }

  /// Escape CSV value
  static String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  /// Import từ CSV string
  static void importFromCsv(
    CellsDataController dataController,
    CellsController controller,
    String csvString,
  ) {
    try {
      final lines = csvString.split('\n');
      final List<List<String>> data = [];
      
      for (final line in lines) {
        if (line.trim().isEmpty) continue;
        final row = _parseCsvLine(line);
        data.add(row);
      }
      
      dataController.loadData(data);
    } catch (e) {
      // Ignore error
    }
  }

  /// Parse CSV line
  static List<String> _parseCsvLine(String line) {
    final List<String> result = [];
    String current = '';
    bool inQuotes = false;
    
    for (int i = 0; i < line.length; i++) {
      final char = line[i];
      
      if (char == '"') {
        if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
          current += '"';
          i++; // Skip next quote
        } else {
          inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        result.add(current);
        current = '';
      } else {
        current += char;
      }
    }
    
    result.add(current);
    return result;
  }

  /// Export ra JSON
  static Map<String, dynamic> exportToJson(
    CellsDataController dataController,
    CellsController controller,
  ) {
    try {
      return dataController.exportToJson();
    } catch (e) {
      return {};
    }
  }

  /// Import từ JSON
  static void importFromJson(
    CellsDataController dataController,
    CellsController controller,
    Map<String, dynamic> json,
  ) {
    try {
      dataController.importFromJson(json);
    } catch (e) {
      // Ignore error
    }
  }
}

