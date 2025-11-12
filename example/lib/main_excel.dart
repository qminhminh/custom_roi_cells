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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📱 ROI Selection',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• Tap to select/deselect a cell'),
                Text('• Drag from unselected cell → Select multiple cells'),
                Text('• Drag from selected cell → Deselect cells'),
                Text('• Selected cells are highlighted in red'),
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
                borderColor: Colors.blue[300]!,
                borderWidth: 0.5,
                cellColor: Colors.white,
                selectedCellColor: Colors.red.withOpacity(0.7),
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
              color: Colors.green.withOpacity(0.1),
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
