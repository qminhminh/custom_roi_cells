# custom_roi_camera_cells

Flutter package for creating grid cells with customizable screen size and number of cells. Useful for creating ROI (Region of Interest) in camera applications.

## Features

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

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  custom_roi_camera_cells: ^0.2.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Method 1: Using with Controller

```dart
import 'package:custom_roi_camera_cells/custom_roi_camera_cells.dart';

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

## Examples

See more detailed examples in the `example/` directory.

## Contributing

Contributions and suggestions are welcome! Please create an issue or pull request on GitHub.

## License

MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Created by [Your Name]
