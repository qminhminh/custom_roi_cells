# custom_roi_cells

Flutter package for creating grid cells with customizable screen size and number of cells. Useful for creating ROI (Region of Interest) in camera applications.

## 📋 Table of Contents

- [Features](#features)
- [Demo](#demo)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Usage](#usage)
- [API Reference](#api-reference)
- [Testing Guide](#testing-guide)
- [Publishing to pub.dev](#publishing-to-pubdev)
- [Contributing](#contributing)
- [License](#license)

---

## Features

### Core Features
- ✅ Customizable screen size (width and height)
- ✅ Customizable number of cells (rows and columns)
- ✅ **Select cells by tap and drag** - Tap to select/deselect, drag to select multiple cells
- ✅ **Highlight selected cells** - Selected cells will be highlighted in red
- ✅ **Save selection as index array** - Example: [0,1,2,3,...]
- ✅ **Custom row and column colors** - Set different colors for specific rows and columns
- ✅ **Custom selected/unselected cell colors** - Different colors for selected and unselected cells
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

---

## Demo

### Screenshots

#### ROI Camera Application Example
![ROI Camera Application](https://raw.githubusercontent.com/qminhminh/custom_roi_cells/master/images/roi.jpg)

*Grid cells overlay on camera feed for defining warning zones (Cảnh báo vùng)*

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

<!-- Option 3: Using GIF for animated demo -->
![Drag Selection](docs/images/demo-drag-select.gif)

*Drag to select multiple cells*

---

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

---

## Quick Start

### 🚀 Running the Example App

#### Method 1: Android Studio (Recommended) ⭐

1. **Open Android Studio**
2. **File → Open** → Select the `example` folder
3. Wait for Android Studio to sync dependencies (1-2 minutes)
4. Select device/emulator from dropdown at the top
5. Press **Run** button (▶) or press **Shift + F10**
6. App will build and run automatically

#### Method 2: Terminal

**Windows (PowerShell or CMD):**
```powershell
cd example
flutter pub get
flutter run
```

**Mac/Linux:**
```bash
cd example
flutter pub get
flutter run
```

#### Method 3: Web (If supported)

```bash
cd example
flutter run -d chrome
```

### 📱 What You'll See

The app displays a 15x15 grid with the following interface:

```
┌─────────────────────────────────────────┐
│  Custom ROI Camera Cells                │
├─────────────────────────────────────────┤
│                                         │
│  ┌───────────────────────────────────┐ │
│  │ 📱 Custom ROI Camera Cells        │ │
│  │ • Tap to select/deselect a cell   │ │
│  │ • Drag to select multiple cells   │ │
│  │ • Selected cells will display in  │ │
│  │   red                             │ │
│  └───────────────────────────────────┘ │
│                                         │
│  Grid Cells (15x15):                   │
│  ┌─────────────────────────────────┐   │
│  │ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ │   │
│  │ ⬜ 🔴 🔴 🔴 ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ │   │
│  │ ⬜ 🔴 🔴 🔴 ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ │   │
│  │ ⬜ 🔴 🔴 🔴 ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ │   │
│  │ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ ⬜ │   │
│  │ ... (15x15 grid)                  │   │
│  └─────────────────────────────────┘   │
│                                         │
│  [Save] [Delete] [Clear]               │
│                                         │
│  ✅ Selected 9 cells:                   │
│  List: 16, 17, 18, 31, 32, ...         │
│  Array: [16,17,18,31,32,33,46,47,48]   │
│                                         │
└─────────────────────────────────────────┘
```

### 🎨 Interface Details

**Colors:**
- Header: Light blue (#E3F2FD)
- Grid background: White
- Unselected cells: White
- Selected cells: Red (70% opacity)
- Cell borders: Light blue (#90CAF9)
- Save button: Blue (#2196F3)
- Delete button: Black (#424242)
- Clear button: Gray (#9E9E9E)

**Sizes:**
- Grid: 600px x 400px
- Cells: ~40px x ~27px (auto-calculated)
- Border: 0.5px

### ✨ How to Use

1. **Tap on cell**: Select/deselect (red = selected)
2. **Drag mouse/finger**: Select multiple cells at once
3. **Save button**: Save selected index list
4. **Delete button**: Delete selected cells
5. **Clear button**: Clear all selection

---

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
  unselectedCellColor: Colors.white, // Color for unselected cells
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

### Method 3.1: Using with Custom Row and Column Colors

```dart
final CellsController controller = CellsController(
  screenWidth: 800.0,
  screenHeight: 400.0,
  cellsRows: 20,
  cellsColumns: 20,
);

CellsWidget(
  controller: controller,
  enableSelection: true,
  // Color for selected cells
  selectedCellColor: Colors.blue.withOpacity(0.5),
  // Color for unselected cells
  unselectedCellColor: Colors.white,
  // Custom colors for specific rows
  rowColors: {
    0: Colors.yellow.withOpacity(0.3),  // Row 0: yellow
    1: Colors.green.withOpacity(0.3),    // Row 1: green
    5: Colors.orange.withOpacity(0.3),   // Row 5: orange
  },
  // Custom colors for specific columns
  columnColors: {
    0: Colors.red.withOpacity(0.3),     // Column 0: red
    2: Colors.purple.withOpacity(0.3),  // Column 2: purple
    10: Colors.cyan.withOpacity(0.3),    // Column 10: cyan
  },
  onSelectionChanged: (indices) {
    print('Selected: $indices');
  },
)
```

**Note:** Color priority: Selected cells > Row colors > Column colors > Unselected cell color

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

---

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
- `unselectedCellColor` (Color?): Unselected cell color (takes priority over cellColor when enableSelection = true)
- `rowColors` (Map<int, Color>?): Map of row index to color for customizing row colors
- `columnColors` (Map<int, Color>?): Map of column index to color for customizing column colors
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

---

## Testing Guide

### 🧪 Test Cases

#### Test 1: Select one cell
```
1. Tap on cell at position (0,0) - index 0
2. Expected: Cell turns red
3. Check: selectedIndices = [0]
```

#### Test 2: Select multiple individual cells
```
1. Tap on cell 0
2. Tap on cell 5
3. Tap on cell 10
4. Expected: 3 red cells
5. Check: selectedIndices = [0, 5, 10]
```

#### Test 3: Drag to select range
```
1. Press and hold cell 20
2. Drag to cell 25
3. Expected: Cells 20-25 all red
4. Check: selectedIndices = [20, 21, 22, 23, 24, 25]
```

#### Test 4: Select rectangle
```
1. Press and hold cell 30 (row 2, column 0)
2. Drag to cell 45 (row 3, column 0)
3. Expected: Select both row 2 and row 3
4. Check: selectedIndices contains cells from 30-44
```

#### Test 5: Save selection
```
1. Select some cells
2. Press Save button
3. Expected: Display SnackBar "✅ Saved X cells"
4. Check: Index array displays correctly
```

#### Test 6: Delete selection
```
1. Select some cells
2. Press Delete button
3. Expected: Cells deselect, display SnackBar
4. Check: selectedIndices = []
```

#### Test 7: Clear selection
```
1. Select multiple cells
2. Press Clear button
3. Expected: All cells deselect
4. Check: selectedIndices = []
```

### ✅ Functionality Checklist

#### Basic Interface
- [ ] App opens
- [ ] Header displays correctly
- [ ] Grid cells display 15x15
- [ ] Save, Delete, Clear buttons display

#### Selection Functionality
- [ ] Tap on cell → Cell turns red
- [ ] Tap again → Cell deselects (returns to white)
- [ ] Drag from one cell to another → Select range
- [ ] Drag diagonally → Select rectangle

#### Result Display
- [ ] Select cells → Display count
- [ ] Select cells → Display index list
- [ ] Select cells → Display JSON array: `[0,1,2,3,...]`

#### Control Buttons
- [ ] Press Save → Save selection and display array
- [ ] Press Delete → Delete selected cells
- [ ] Press Clear → Clear all selection

### ❓ Troubleshooting

#### Error "Flutter not found"
- Ensure Flutter SDK is installed
- Add Flutter to PATH
- Check installation: `flutter --version`

#### Error "No devices found"
- Start Android Emulator in Android Studio
- Or connect phone and enable USB Debugging
- Create emulator: **Tools → Device Manager → Create Device**

#### Build error
- Run `flutter clean`
- Run `flutter pub get` again
- Delete `.dart_tool` and `build` folders

#### Cells can't be selected
- Check `enableSelection: true` in code
- Ensure controller is properly initialized

---

## Publishing to pub.dev

### Step 1: Preparation

1. Ensure Flutter SDK is installed
2. Log in to pub.dev with Google account
3. Check all required files:
   - `pubspec.yaml` - updated description and version
   - `README.md` - has complete documentation
   - `CHANGELOG.md` - has changelog
   - `LICENSE` - has license (MIT)
   - `example/` - has example app

### Step 2: Code Check

Run the following commands to check:

```bash
# Format code
flutter format .

# Analyze code
flutter analyze

# Run tests
flutter test

# Run example app
cd example
flutter run
```

### Step 3: Update Information in pubspec.yaml

Ensure the following information is correct:
- `name`: Package name (must be unique on pub.dev)
- `description`: Brief description (maximum 60 characters)
- `version`: Current version
- `homepage`: GitHub repository URL
- `repository`: GitHub repository URL
- `issue_tracker`: GitHub issues URL

**Note:** Update GitHub URLs in `pubspec.yaml` with your actual repository.

### Step 4: Create pub.dev Account

1. Visit https://pub.dev
2. Log in with Google account
3. Go to "Publisher" section to create publisher (if not already created)

### Step 5: Publish Package

```bash
# Check package before publishing
flutter pub publish --dry-run

# Publish package
flutter pub publish
```

### Step 6: After Publishing

1. Check package on pub.dev
2. Update README if needed
3. Create tags on GitHub:
   ```bash
   git tag v0.2.0
   git push origin v0.2.0
   ```

### Important Notes

- **Version**: Must increment version for each publish
- **Changelog**: Always update CHANGELOG.md when there are changes
- **Tests**: Ensure all tests pass
- **Documentation**: Ensure README.md is complete and clear
- **License**: Must have license file

### Update Package After Publishing

1. Update version in `pubspec.yaml`
2. Update `CHANGELOG.md`
3. Commit and push code
4. Run `flutter pub publish`
5. Create new tag on GitHub

### Publishing Troubleshooting

- **Error "Package already exists"**: Package name is already in use, need to change name
- **Error "Invalid version"**: Version format is incorrect (must be x.y.z)
- **Error "Missing files"**: Missing required files (README, LICENSE, etc.)

---

## Contributing

Contributions and suggestions are welcome! Please create an issue or pull request on GitHub.

## License

MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Created by [Your Name]
