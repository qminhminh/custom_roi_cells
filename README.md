# custom_roi_cells

Flutter package for creating grid cells with customizable screen size and number of cells. Useful for creating ROI (Region of Interest) in camera applications.

## Features

### Core Features
- ✅ Customizable screen size (width and height)
- ✅ Customizable number of cells (rows and columns)
- ✅ **Select cells by tap and drag** - Tap to select/deselect, drag to select multiple cells
- ✅ **Highlight selected cells** - Selected cells will be highlighted in red
- ✅ **Save selection as index array** - Example: [0,1,2,3,...]
- ✅ Widget with form input to enter parameters
- ✅ Controller to manage state
- ✅ Callback when cell is selected
- ✅ Customizable colors, border, and cell number display
- ✅ Control buttons: Save, Delete, Clear selection
- ✅ Responsive and easy to use

### Excel-like Features (NEW!)
- ✅ **Editable cells** - Click to edit text in cells
- ✅ **Data binding** - Load data from `List<List<String>>` or `List<Map<String, dynamic>>`
- ✅ **Display data as table** - Show data in table format with headers
- ✅ **Cell formatting** - Customize text color, background color, font size, font weight, text alignment per cell
- ✅ **Search functionality** - Search text in cells
- ✅ **Sort functionality** - Sort data by column(s)
- ✅ **Filter functionality** - Filter rows by condition
- ✅ **Export/Import** - Export to CSV, JSON and import from CSV, JSON
- ✅ **Header rows** - Display header row with custom styling
- ✅ **Cell data management** - Manage cell data with `CellsDataController`

## Demo

### Screenshots

#### Main Interface
![Main Interface](docs/images/demo-main.png)

*Grid cells with selection capability*

#### Selection Functionality
![Selection](docs/images/demo-selection.png)

*Tap and drag to select multiple cells*

#### Control Buttons
![Control Buttons](docs/images/demo-buttons.png)

*Save, Delete, and Clear buttons*

#### Selection Result
![Selection Result](docs/images/demo-result.png)

*Display selected indices as array*

### Video Demo

<!-- Add your demo video here -->
<!-- Option 1: Using GitHub's video support -->
<!--
https://user-images.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/docs/images/demo-video.mp4
-->

<!-- Option 2: Using YouTube or other video hosting -->
<!--
[![Demo Video](docs/images/demo-thumbnail.png)](https://youtube.com/watch?v=YOUR_VIDEO_ID)
-->

<!-- Option 3: Using GIF for animated demo -->
![Drag Selection](docs/images/demo-drag-select.gif)

*Drag to select multiple cells*

### How to Add Your Own Demo

1. **Take screenshots** of your app:
   - Run the example app: `cd example && flutter run`
   - Take screenshots of the main interface
   - Take screenshots of selection functionality
   - Take screenshots of control buttons
   - Take screenshots of selection results

2. **Create animated GIF** (optional):
   - Record screen while using the app
   - Convert to GIF using tools like [LICEcap](https://www.cockos.com/licecap/) or [GIF Brewery](https://gfycat.com/gifbrewery)
   - Save as `docs/images/demo-drag-select.gif`

3. **Create video** (optional):
   - Record screen while demonstrating features
   - Export as MP4
   - Upload to YouTube or GitHub
   - Add link to README

4. **Add images to repository**:
   - Create `docs/images/` directory
   - Add your images to `docs/images/`
   - Update paths in README.md

**Note:** Currently, the demo images are placeholders. Replace them with your actual screenshots and videos.

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  custom_roi_cells: ^0.2.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Method 1: Using with Controller

```dart
import 'package:custom_roi_cells/custom_roi_cells.dart';

class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  // Initialize controller with custom parameters
  final CellsController controller = CellsController(
    screenWidth: 2048.0,
    screenHeight: 500.0,
    cellsRows: 32,
    cellsColumns: 23,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CellsWidget(
      controller: controller,
      borderColor: Colors.blue,
      borderWidth: 1.0,
      cellColor: Colors.grey.withOpacity(0.1),
      onCellTap: (row, column) {
        print('Cell selected: Row $row, Column $column');
      },
    );
  }
}
```


### Method 2: Using directly with parameters

```dart
CellsWidget(
  screenWidth: 2048.0,
  screenHeight: 500.0,
  cellsRows: 32,
  cellsColumns: 23,
  borderColor: Colors.blue,
  borderWidth: 0.5,
  showCellNumbers: true,
  onCellTap: (row, column) {
    print('Cell at row $row, column $column');
  },
)
```

### Method 3: Using with Selection (Tap and Drag to select cells)

```dart
final CellsController controller = CellsController(
  screenWidth: 800.0,
  screenHeight: 400.0,
  cellsRows: 20,
  cellsColumns: 20,
);

List<int> selectedIndices = [];

CellsWidget(
  controller: controller,
  enableSelection: true, // Enable selection feature
  selectedCellColor: Colors.red.withOpacity(0.6),
  showCellNumbers: true, // Display cell indices
  onSelectionChanged: (indices) {
    selectedIndices = indices;
    print('Selected: $indices');
  },
)

// Selection control buttons
CellsSelectionButtons(
  controller: controller,
  onSave: (indices) {
    print('Saved: $indices');
    // indices is an array [0,1,2,3,...]
  },
  onDelete: (indices) {
    print('Deleted: $indices');
  },
  onClear: () {
    print('Cleared all selection');
  },
)
```

### Method 4: Using Widget with Form Input

```dart
CellsInputWidget(
  controller: controller,
  showCellsPreview: true,
  onChanged: (width, height, rows, columns) {
    print('Width: $width, Height: $height');
    print('Rows: $rows, Columns: $columns');
  },
)
```

### Method 5: Using as Excel-like Table (NEW!)

#### Display Data from List<List<String>>

```dart
final CellsController controller = CellsController(
  screenWidth: 800.0,
  screenHeight: 600.0,
  cellsRows: 10,
  cellsColumns: 5,
);

final data = [
  ['Name', 'Age', 'City', 'Email', 'Phone'],
  ['John', '25', 'New York', 'john@example.com', '123-456-7890'],
  ['Jane', '30', 'London', 'jane@example.com', '098-765-4321'],
  ['Bob', '35', 'Paris', 'bob@example.com', '555-123-4567'],
];

CellsTableWidget(
  controller: controller,
  data: data,
  enableEdit: true, // Allow editing cells
  showHeader: true, // Show header row
  headerBackgroundColor: Colors.blue[100],
  onDataChanged: (newData) {
    print('Data changed: $newData');
  },
)
```

#### Display Data from List<Map>

```dart
final mapData = [
  {'name': 'John', 'age': '25', 'city': 'New York'},
  {'name': 'Jane', 'age': '30', 'city': 'London'},
  {'name': 'Bob', 'age': '35', 'city': 'Paris'},
];

CellsTableWidget(
  controller: controller,
  mapData: mapData,
  columns: ['name', 'age', 'city'], // Column order
  enableEdit: true,
  showHeader: true,
)
```

#### Using CellsDataController for Advanced Features

```dart
final CellsController controller = CellsController(
  screenWidth: 800.0,
  screenHeight: 600.0,
  cellsRows: 20,
  cellsColumns: 10,
);

final CellsDataController dataController = CellsDataController(controller);

// Load data
dataController.loadData([
  ['Header1', 'Header2', 'Header3'],
  ['Data1', 'Data2', 'Data3'],
  ['Data4', 'Data5', 'Data6'],
]);

// Edit cell
dataController.setCellText(5, 'New Text');

// Get cell text
final text = dataController.getCellText(5);

// Format cell
dataController.setCellData(5, CellData(
  text: 'Formatted Text',
  backgroundColor: Colors.yellow,
  textColor: Colors.red,
  fontWeight: FontWeight.bold,
  textAlign: TextAlign.center,
));

// Display with CellsDataWidget
CellsDataWidget(
  controller: controller,
  dataController: dataController,
  enableEdit: true,
)
```

#### Search, Sort, and Filter

```dart
// Search
final searchResults = CellsSearch.searchCells(
  dataController,
  controller,
  'search text',
  caseSensitive: false,
);

// Sort by column
CellsSort.sortByColumn(
  dataController,
  controller,
  0, // Column index
  ascending: true,
  startRow: 1, // Skip header row
);

// Filter rows
final matchingRows = CellsFilter.filterRows(
  dataController,
  controller,
  (rowData) => rowData[0].contains('John'), // Filter condition
);

// Export to CSV
final csvString = CellsExportImport.exportToCsv(dataController, controller);

// Export to JSON
final jsonData = CellsExportImport.exportToJson(dataController, controller);

// Import from CSV
CellsExportImport.importFromCsv(dataController, controller, csvString);

// Import from JSON
CellsExportImport.importFromJson(dataController, controller, jsonData);
```

## API Reference

### CellsWidget

Main widget to display grid cells.

**Parameters:**

- `controller` (CellsController?): Controller to manage state
- `screenWidth` (double?): Screen width
- `screenHeight` (double?): Screen height
- `cellsRows` (int?): Number of cell rows
- `cellsColumns` (int?): Number of cell columns
- `borderColor` (Color?): Border color (default: Colors.grey)
- `borderWidth` (double?): Border width (default: 1.0)
- `cellColor` (Color?): Cell background color (default: Colors.transparent)
- `onCellTap` (void Function(int row, int column)?): Callback when cell is tapped
- `showCellNumbers` (bool): Show cell numbers (default: false)
- `numberColor` (Color?): Number text color
- `numberFontSize` (double?): Number font size
- `enableSelection` (bool): Enable cell selection by tap and drag (default: false)
- `selectedCellColor` (Color?): Selected cell color (default: Colors.red.withOpacity(0.5))
- `onSelectionChanged` (void Function(List<int> selectedIndices)?): Callback when selection changes, returns list of indices
- `onSaveSelection` (void Function(List<int> selectedIndices)?): Callback when saving selection

### CellsSelectionButtons

Widget displaying selection control buttons (Save, Delete, Clear).

**Parameters:**

- `controller` (CellsController): Controller to manage (required)
- `onSave` (void Function(List<int> selectedIndices)?): Callback when Save button is pressed
- `onDelete` (void Function(List<int> selectedIndices)?): Callback when Delete button is pressed
- `onClear` (VoidCallback?): Callback when Clear button is pressed
- `saveButtonColor` (Color?): Save button background color (default: Colors.blue)
- `deleteButtonColor` (Color?): Delete button background color (default: Colors.black87)
- `clearButtonColor` (Color?): Clear button background color (default: Colors.grey)
- `showSelectionCount` (bool): Show number of selected cells (default: true)

### CellsInputWidget

Widget with form input to enter parameters and display preview.

**Parameters:**

- `controller` (CellsController?): Controller to manage
- `onChanged` (void Function(double width, double height, int rows, int columns)?): Callback when values change
- `showCellsPreview` (bool): Show cells preview (default: true)

### CellsDataWidget

Widget to display and edit data in cells (Excel-like).

**Parameters:**

- `controller` (CellsController): Controller to manage grid (required)
- `dataController` (CellsDataController?): Data controller to manage cell data
- `enableEdit` (bool): Allow editing cells (default: false)
- `showHeader` (bool): Show header row (default: false)
- `headerBackgroundColor` (Color?): Header background color
- `headerTextStyle` (TextStyle?): Header text style
- `borderColor` (Color?): Cell border color
- `borderWidth` (double?): Cell border width
- `defaultCellColor` (Color?): Default cell background color
- `editingCellBorderColor` (Color?): Border color when editing
- `onCellTextChanged` (void Function(int index, String text)?): Callback when cell text changes
- `onCellTap` (void Function(int index)?): Callback when cell is tapped

### CellsTableWidget

Widget to display data as a table (Excel-like) with support for `List<List<String>>` or `List<Map>`.

**Parameters:**

- `controller` (CellsController): Controller to manage grid (required)
- `dataController` (CellsDataController?): Data controller to manage cell data
- `data` (List<List<String>>?): Data as rows and columns
- `mapData` (List<Map<String, dynamic>>?): Data as list of maps
- `columns` (List<String>?): Column names (when using mapData)
- `enableEdit` (bool): Allow editing cells (default: false)
- `showHeader` (bool): Show header row (default: true)
- `headerBackgroundColor` (Color?): Header background color
- `headerTextStyle` (TextStyle?): Header text style
- `borderColor` (Color?): Cell border color
- `borderWidth` (double?): Cell border width
- `defaultCellColor` (Color?): Default cell background color
- `onDataChanged` (void Function(List<List<String>> data)?): Callback when data changes

### CellsDataController

Controller to manage cell data (text, formatting, etc.).

**Properties:**

- `getCellText(int index)`: Get cell text by index
- `setCellText(int index, String text)`: Set cell text by index
- `getCellData(int index)`: Get CellData by index
- `setCellData(int index, CellData cellData)`: Set CellData by index
- `loadData(List<List<String>> data)`: Load data from List<List<String>>
- `loadDataFromMaps(List<Map<String, dynamic>> data, {List<String>? columns})`: Load data from List<Map>
- `exportData()`: Export data as List<List<String>>
- `exportToJson()`: Export data as JSON
- `exportToCsv()`: Export data as CSV string
- `importFromJson(Map<String, dynamic> json)`: Import data from JSON
- `clearData()`: Clear all data
- `clearCell(int index)`: Clear cell data

### CellData

Class to store cell data and formatting.

**Properties:**

- `text` (String): Cell text
- `backgroundColor` (Color?): Background color
- `textColor` (Color?): Text color
- `fontSize` (double?): Font size
- `fontWeight` (FontWeight?): Font weight
- `textAlign` (TextAlign?): Text alignment
- `isMerged` (bool): Is cell merged
- `rowSpan` (int): Row span if merged
- `colSpan` (int): Column span if merged

### CellsController

Controller to manage cells state.

**Constructor:**

```dart
CellsController({
  required double screenWidth,    // Required, must be > 0
  required double screenHeight,   // Required, must be > 0
  required int cellsRows,         // Required, must be > 0
  required int cellsColumns,      // Required, must be > 0
})
```

**Note:** All parameters are required and must be greater than 0. If a value <= 0 is passed, an `ArgumentError` will be thrown.

**Properties:**

- `screenWidth` (double): Screen width
- `screenHeight` (double): Screen height
- `cellsRows` (int): Number of cell rows
- `cellsColumns` (int): Number of cell columns
- `cellWidth` (double): Width of each cell (read-only)
- `cellHeight` (double): Height of each cell (read-only)
- `totalCells` (int): Total number of cells (read-only)
- `selectedCellIndices` (Set<int>): List of selected cell indices (read-only)
- `selectedCellsCount` (int): Number of selected cells (read-only)

**Methods:**

- `isCellSelected(int index)`: Check if a cell is selected
- `selectCell(int index)`: Select a cell by index
- `deselectCell(int index)`: Deselect a cell by index
- `selectCells(List<int> indices)`: Select multiple cells by index list
- `selectCellRange(int startIndex, int endIndex)`: Select a range of cells
- `selectRow(int row)`: Select an entire row
- `selectColumn(int column)`: Select an entire column
- `clearSelection()`: Clear all selection
- `deleteSelectedCells()`: Delete selected cells
- `getSelectedIndices()`: Get list of selected indices as sorted array
- `addListener(void Function() listener)`: Register listener
- `removeListener(void Function() listener)`: Unregister listener
- `dispose()`: Dispose resources

### CellsSearch

Utility class for searching text in cells.

**Methods:**

- `searchCells(CellsDataController, CellsController, String searchText, {bool caseSensitive, bool matchWholeWord})`: Search for text in cells, returns list of matching cell indices
- `replaceAll(CellsDataController, CellsController, String searchText, String replaceText, {bool caseSensitive})`: Replace all occurrences of search text, returns count of replacements

### CellsSort

Utility class for sorting data in cells.

**Methods:**

- `sortByColumn(CellsDataController, CellsController, int columnIndex, {bool ascending, int startRow})`: Sort data by column
- `sortByMultipleColumns(CellsDataController, CellsController, List<int> columnIndexes, {List<bool>? ascending, int startRow})`: Sort data by multiple columns

### CellsFilter

Utility class for filtering data in cells.

**Methods:**

- `filterRows(CellsDataController, CellsController, bool Function(List<String> rowData) filterFunction)`: Filter rows by condition, returns list of matching row indices

### CellsExportImport

Utility class for exporting and importing data.

**Methods:**

- `exportToCsv(CellsDataController, CellsController)`: Export data to CSV string
- `importFromCsv(CellsDataController, CellsController, String csvString)`: Import data from CSV string
- `exportToJson(CellsDataController, CellsController)`: Export data to JSON
- `importFromJson(CellsDataController, CellsController, Map<String, dynamic> json)`: Import data from JSON

## Examples

See more detailed examples in the `example/` directory.

## Contributing

Contributions and suggestions are welcome! Please create an issue or pull request on GitHub.

## License

MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Created by [Your Name]
