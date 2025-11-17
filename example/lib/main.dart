import 'package:flutter/material.dart';
import 'package:custom_roi_cells/custom_roi_cells.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom ROI Cells Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Custom ROI Cells'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'ROI Selection', icon: Icon(Icons.grid_on)),
            Tab(text: 'Excel Table', icon: Icon(Icons.table_chart)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [ROISelectionPage(), ExcelTablePage()],
      ),
    );
  }
}

/// ROI Selection Page
class ROISelectionPage extends StatefulWidget {
  const ROISelectionPage({super.key});

  @override
  State<ROISelectionPage> createState() => _ROISelectionPageState();
}

class _ROISelectionPageState extends State<ROISelectionPage> {
  final CellsController controller = CellsController(
    screenWidth: 600.0,
    screenHeight: 800.0,
    cellsRows: 25,
    cellsColumns: 15,
  );

  List<int> selectedIndices = [];
  DragSelectionMode dragMode = DragSelectionMode.multipleCells;
  final List<int> sampleServerSelectionA = [0, 1, 2, 15, 16, 17, 45, 60];
  final List<int> sampleServerSelectionB = [10, 11, 12, 30, 31, 32, 70, 71];

  // Màu sắc tùy chỉnh
  Color selectedCellColor = Colors.red.withValues(alpha: 0.7);
  Color borderColor = Colors.blue[300]!;
  Color? rowColor;
  Color? columnColor;
  bool enableRowColor = false;
  bool enableColumnColor = false;

  // Tạo map màu cho tất cả các hàng
  Map<int, Color> _generateRowColors(Color color) {
    final Map<int, Color> rowColors = {};
    for (int i = 0; i < controller.cellsRows; i++) {
      rowColors[i] = color;
    }
    return rowColors;
  }

  // Tạo map màu cho tất cả các cột
  Map<int, Color> _generateColumnColors(Color color) {
    final Map<int, Color> columnColors = {};
    for (int i = 0; i < controller.cellsColumns; i++) {
      columnColors[i] = color;
    }
    return columnColors;
  }

  // Hiển thị color picker
  void _showColorPicker(
    BuildContext context,
    Color currentColor,
    void Function(Color) onColorChanged,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => ColorPickerDialog(
            currentColor: currentColor,
            onColorChanged: onColorChanged,
          ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _applyServerSelection(List<int> data) {
    controller.setSelectedCells(data);
    setState(() {
      selectedIndices = controller.getSelectedIndices();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Applied server selection: [${data.take(10).join(",")}${data.length > 10 ? ", ..." : ""}]',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📱 ROI Selection',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('• Tap to select/deselect a cell'),
                Text(
                  '• Drag mode: ${dragMode == DragSelectionMode.singleCell ? "Select each cell" : "Select multiple cells (rectangle)"}',
                ),
                const Text('• Drag from unselected cell → Select cells'),
                const Text('• Drag from selected cell → Deselect cells'),
                const Text('• Selected cells are highlighted in red'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Drag Selection Mode: '),
                    const SizedBox(width: 8),
                    ChoiceChips(
                      selected: dragMode,
                      onChanged: (mode) {
                        setState(() {
                          dragMode = mode;
                          controller.clearSelection();
                          selectedIndices = [];
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.cyan.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.cyan),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '☁️ Server Selection Demo',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Dataset A: ${sampleServerSelectionA.toString()}',
                  style: const TextStyle(fontSize: 13),
                ),
                Text(
                  'Dataset B: ${sampleServerSelectionB.toString()}',
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      onPressed:
                          () => _applyServerSelection(sampleServerSelectionA),
                      icon: const Icon(Icons.cloud_download),
                      label: const Text('Apply Dataset A'),
                    ),
                    ElevatedButton.icon(
                      onPressed:
                          () => _applyServerSelection(sampleServerSelectionB),
                      icon: const Icon(Icons.cloud_download_outlined),
                      label: const Text('Apply Dataset B'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tip: Use controller.setSelectedCells(serverData) to highlight cells from server.',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Color Customization Panel
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.purple),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🎨 Color Customization',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Selected Cell Color
                Row(
                  children: [
                    const Expanded(
                      child: Text('Highlight color (selected cell):'),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap:
                          () => _showColorPicker(context, selectedCellColor, (
                            color,
                          ) {
                            setState(() {
                              selectedCellColor = color;
                            });
                          }),
                      child: Container(
                        width: 50,
                        height: 40,
                        decoration: BoxDecoration(
                          color: selectedCellColor,
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Border Color (Grid Lines)
                Row(
                  children: [
                    const Expanded(child: Text('Grid line color:')),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap:
                          () => _showColorPicker(context, borderColor, (color) {
                            setState(() {
                              borderColor = color;
                            });
                          }),
                      child: Container(
                        width: 50,
                        height: 40,
                        decoration: BoxDecoration(
                          color: borderColor,
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Row Color
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Checkbox(
                            value: enableRowColor,
                            onChanged: (value) {
                              setState(() {
                                enableRowColor = value ?? false;
                                if (!enableRowColor) {
                                  rowColor = null;
                                } else if (rowColor == null) {
                                  rowColor = Colors.yellow.withValues(
                                    alpha: 0.3,
                                  );
                                }
                              });
                            },
                          ),
                          const Expanded(child: Text('Row color:')),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (enableRowColor)
                      GestureDetector(
                        onTap:
                            () => _showColorPicker(
                              context,
                              rowColor ?? Colors.yellow.withValues(alpha: 0.3),
                              (color) {
                                setState(() {
                                  rowColor = color;
                                });
                              },
                            ),
                        child: Container(
                          width: 50,
                          height: 40,
                          decoration: BoxDecoration(
                            color:
                                rowColor ??
                                Colors.yellow.withValues(alpha: 0.3),
                            border: Border.all(color: Colors.grey, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 50,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.block, color: Colors.grey),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                // Column Color
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Checkbox(
                            value: enableColumnColor,
                            onChanged: (value) {
                              setState(() {
                                enableColumnColor = value ?? false;
                                if (!enableColumnColor) {
                                  columnColor = null;
                                } else if (columnColor == null) {
                                  columnColor = Colors.blue.withValues(
                                    alpha: 0.3,
                                  );
                                }
                              });
                            },
                          ),
                          const Expanded(child: Text('Column color:')),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (enableColumnColor)
                      GestureDetector(
                        onTap:
                            () => _showColorPicker(
                              context,
                              columnColor ?? Colors.blue.withValues(alpha: 0.3),
                              (color) {
                                setState(() {
                                  columnColor = color;
                                });
                              },
                            ),
                        child: Container(
                          width: 50,
                          height: 40,
                          decoration: BoxDecoration(
                            color:
                                columnColor ??
                                Colors.blue.withValues(alpha: 0.3),
                            border: Border.all(color: Colors.grey, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 50,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.block, color: Colors.grey),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Grid Cells (${controller.cellsRows}x${controller.cellsColumns}):',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Center(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey[300]!, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CellsWidget(
                controller: controller,
                enableSelection: true,
                dragSelectionMode: dragMode,
                borderColor: borderColor,
                borderWidth: 0.5,
                cellColor: Colors.white,
                selectedCellColor: selectedCellColor,
                initialSelectedCells: sampleServerSelectionA,
                rowColors:
                    enableRowColor && rowColor != null
                        ? _generateRowColors(rowColor!)
                        : null,
                columnColors:
                    enableColumnColor && columnColor != null
                        ? _generateColumnColors(columnColor!)
                        : null,
                onSelectionChanged: (indices) {
                  setState(() {
                    selectedIndices = indices;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          CellsSelectionButtons(
            controller: controller,
            onSave: (indices) {
              setState(() {
                selectedIndices = indices;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('✅ Saved ${indices.length} cells')),
              );
            },
            onDelete: (indices) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('🗑️ Deleted ${indices.length} cells')),
              );
            },
            onClear: () {
              setState(() {
                selectedIndices = [];
              });
            },
          ),
          if (selectedIndices.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[300]!, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected: ${selectedIndices.length} cells',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    '[${selectedIndices.join(",")}]',
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Excel Table Page
class ExcelTablePage extends StatefulWidget {
  const ExcelTablePage({super.key});

  @override
  State<ExcelTablePage> createState() => _ExcelTablePageState();
}

class _ExcelTablePageState extends State<ExcelTablePage> {
  final CellsController controller = CellsController(
    screenWidth: 1200.0, // Tăng width để text có nhiều chỗ hơn
    screenHeight: 600.0,
    cellsRows: 10,
    cellsColumns: 5,
  );

  late CellsDataController dataController;
  late CellsSizeController sizeController;
  List<List<String>> tableData = [];
  String searchText = '';
  List<int> searchResults = [];
  bool showSizeInput = false;

  @override
  void initState() {
    super.initState();
    dataController = CellsDataController(controller);
    sizeController = CellsSizeController(controller);
    sizeController.enableCustomSizes = true;
    _loadSampleData();
    dataController.addListener(_onDataChanged);
    sizeController.addListener(_onDataChanged);
  }

  void _loadSampleData() {
    final data = [
      ['Name', 'Age', 'City', 'Email', 'Phone'],
      ['John', '25', 'New York', 'john@example.com', '123-456-7890'],
      ['Jane', '30', 'London', 'jane@example.com', '098-765-4321'],
      ['Bob', '35', 'Paris', 'bob@example.com', '555-123-4567'],
      ['Alice', '28', 'Tokyo', 'alice@example.com', '111-222-3333'],
      ['Charlie', '32', 'Berlin', 'charlie@example.com', '444-555-6666'],
    ];
    dataController.loadData(data);
    tableData = data;
  }

  void _onDataChanged() {
    setState(() {
      tableData = dataController.exportData();
    });
  }

  @override
  void dispose() {
    dataController.removeListener(_onDataChanged);
    sizeController.removeListener(_onDataChanged);
    dataController.dispose();
    sizeController.dispose();
    controller.dispose();
    super.dispose();
  }

  void _search() {
    if (searchText.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }
    setState(() {
      searchResults = CellsSearch.searchCells(
        dataController,
        controller,
        searchText,
        caseSensitive: false,
      );
    });
  }

  void _sortByColumn(int columnIndex) {
    CellsSort.sortByColumn(
      dataController,
      controller,
      columnIndex,
      ascending: true,
      startRow: 1, // Skip header
    );
  }

  void _exportToCsv() {
    final csv = CellsExportImport.exportToCsv(dataController, controller);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('CSV exported (${csv.length} characters)'),
        action: SnackBarAction(
          label: 'Copy',
          onPressed: () {
            // Copy to clipboard (would need clipboard package)
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📊 Excel-like Table',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• Click cell to edit'),
                Text('• Search, sort, filter data'),
                Text('• Export to CSV/JSON'),
                Text('• Customize cell formatting'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Search bar
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    hintText: 'Enter text to search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                    _search();
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _search, child: const Text('Search')),
            ],
          ),
          if (searchResults.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Found ${searchResults.length} results',
              style: const TextStyle(fontSize: 14, color: Colors.blue),
            ),
          ],
          const SizedBox(height: 16),
          // Toolbar
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => _sortByColumn(0),
                icon: const Icon(Icons.sort),
                label: const Text('Sort by Name'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _sortByColumn(1),
                icon: const Icon(Icons.sort),
                label: const Text('Sort by Age'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _exportToCsv,
                icon: const Icon(Icons.download),
                label: const Text('Export CSV'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    showSizeInput = !showSizeInput;
                  });
                },
                icon: Icon(showSizeInput ? Icons.close : Icons.tune),
                label: Text(showSizeInput ? 'Hide Sizes' : 'Custom Sizes'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Size Input Widget
          if (showSizeInput) ...[
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[300]!, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Custom Column/Row Sizes:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 300,
                    child: CellsSizeInputWidget(
                      controller: controller,
                      sizeController: sizeController,
                      onSizeChanged: (index, size, isColumn) {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          // Table
          Text(
            'Table Data (${controller.cellsRows}x${controller.cellsColumns}):',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Center(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey[300]!, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CellsTableWidget(
                controller: controller,
                dataController: dataController,
                sizeController: sizeController,
                enableEdit: true,
                showHeader: true,
                headerBackgroundColor: Colors.blue[100],
                borderColor: Colors.grey[400],
                borderWidth: 1.0,
                onDataChanged: (data) {
                  setState(() {
                    tableData = data;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Data info
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[300]!, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Data Info:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text('Rows: ${tableData.length}'),
                Text(
                  'Columns: ${tableData.isNotEmpty ? tableData[0].length : 0}',
                ),
                const SizedBox(height: 12),
                const Text(
                  'Sample Data:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (tableData.isNotEmpty)
                  ...tableData.take(3).map((row) => Text(row.join(' | '))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Color Picker Dialog
class ColorPickerDialog extends StatefulWidget {
  final Color currentColor;
  final void Function(Color) onColorChanged;

  const ColorPickerDialog({
    super.key,
    required this.currentColor,
    required this.onColorChanged,
  });

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color selectedColor;
  double opacity = 1.0;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.currentColor;
    opacity = widget.currentColor.opacity;
  }

  // Danh sách màu cơ bản
  final List<Color> presetColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.grey,
    Colors.black,
    Colors.white,
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Color'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Hiển thị màu đã chọn
            Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: selectedColor.withValues(alpha: opacity),
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Selected Color',
                  style: TextStyle(
                    color:
                        selectedColor.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Opacity slider
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Opacity: ${(opacity * 100).toInt()}%'),
                Slider(
                  value: opacity,
                  min: 0.0,
                  max: 1.0,
                  divisions: 100,
                  onChanged: (value) {
                    setState(() {
                      opacity = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Preset colors
            const Text(
              'Preset Colors:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  presetColors.map((color) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: color,
                          border: Border.all(
                            color:
                                selectedColor == color
                                    ? Colors.black
                                    : Colors.grey,
                            width: selectedColor == color ? 3 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:
                            selectedColor == color
                                ? const Icon(Icons.check, color: Colors.white)
                                : null,
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),
            // RGB sliders
            _buildColorSlider('Red', selectedColor.red, 255, (value) {
              setState(() {
                selectedColor = Color.fromRGBO(
                  value.toInt(),
                  selectedColor.green,
                  selectedColor.blue,
                  opacity,
                );
              });
            }),
            _buildColorSlider('Green', selectedColor.green, 255, (value) {
              setState(() {
                selectedColor = Color.fromRGBO(
                  selectedColor.red,
                  value.toInt(),
                  selectedColor.blue,
                  opacity,
                );
              });
            }),
            _buildColorSlider('Blue', selectedColor.blue, 255, (value) {
              setState(() {
                selectedColor = Color.fromRGBO(
                  selectedColor.red,
                  selectedColor.green,
                  value.toInt(),
                  opacity,
                );
              });
            }),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onColorChanged(selectedColor.withValues(alpha: opacity));
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _buildColorSlider(
    String label,
    int value,
    int max,
    void Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: $value'),
        Slider(
          value: value.toDouble(),
          min: 0,
          max: max.toDouble(),
          divisions: max,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// Widget để chọn chế độ drag selection
class ChoiceChips extends StatelessWidget {
  final DragSelectionMode selected;
  final void Function(DragSelectionMode) onChanged;

  const ChoiceChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ChoiceChip(
          label: const Text('Single Cell'),
          selected: selected == DragSelectionMode.singleCell,
          onSelected: (isSelected) {
            if (isSelected) {
              onChanged(DragSelectionMode.singleCell);
            }
          },
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          label: const Text('Multiple Cells'),
          selected: selected == DragSelectionMode.multipleCells,
          onSelected: (isSelected) {
            if (isSelected) {
              onChanged(DragSelectionMode.multipleCells);
            }
          },
        ),
      ],
    );
  }
}
