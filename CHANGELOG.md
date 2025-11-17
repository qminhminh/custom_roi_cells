## 0.3.8

* **Server Selection Support:**
  * Added `CellsController.setSelectedCells(List<int>)` to replace the current selection with any list of indices (e.g., data from server/API)
  * Added `initialSelectedCells` parameter to `CellsWidget` for pre-selecting cells on first render
  * Example app now demonstrates loading two sample datasets from a simulated server and applying them to the grid
* **UI Enhancements:**
  * Added “Server Selection Demo” section with action buttons in the example app
  * Grid preview now highlights server data by default using `initialSelectedCells`
* **Documentation:**
  * Updated README usage examples and API reference to cover the new selection APIs

## 0.3.7

* **Bug Fixes:**
  * Fixed tap selection not working - simplified tap/drag logic for better reliability
  * Improved pointer event handling to properly distinguish between tap and drag gestures
  * Removed unnecessary GestureDetector wrapper that was blocking tap events
* **New Features:**
  * Added grid line color customization option in example app
  * Users can now customize border/grid line color through UI
* **UI Improvements:**
  * Translated all UI text to English for better internationalization
  * Improved color customization panel layout and organization
* **Code Quality:**
  * Simplified tap detection logic for better performance
  * Removed unused variables and improved code cleanliness

## 0.3.6

* **Code Quality Improvements:**
  * Fixed static analysis issues - removed unnecessary library names
  * Replaced deprecated `withOpacity` with `withValues` for better precision
  * Fixed unnecessary imports (removed `foundation.dart` where `material.dart` is sufficient)
  * Improved code formatting and consistency
  * Fixed angle brackets in documentation comments (using backticks for code formatting)
  * Enhanced code readability with better formatting
* **Documentation Fixes:**
  * Fixed image URL in README.md to use correct branch name (`master` instead of `main`)
  * Improved documentation formatting

## 0.3.5

* **Custom Row and Column Colors (NEW!):**
  * Added `rowColors` parameter to `CellsWidget` for customizing colors by row index
  * Added `columnColors` parameter to `CellsWidget` for customizing colors by column index
  * Added `unselectedCellColor` parameter for separate color control of unselected cells
  * Color priority: Selected cells > Row colors > Column colors > Unselected cell color
  * Support setting different colors for specific rows and columns independently
  * Perfect for highlighting specific rows/columns in grid layouts
* **Documentation Improvements:**
  * Updated README.md with comprehensive documentation
  * Added examples for custom row and column colors
  * Improved API reference documentation
  * Added testing guide and troubleshooting section

## 0.3.4

* **Custom Column/Row Sizes (NEW!):**
  * Added `CellsSizeController` to manage custom sizes for columns and rows
  * Added `CellsSizeInputWidget` for users to input custom column widths and row heights
  * Support custom width for each column independently
  * Support custom height for each row independently
  * Auto-switch from GridView to Table widget when custom sizes are enabled
  * Display default and actual sizes for each column/row
  * Reset individual or all sizes to default
  * Seamless integration with `CellsDataWidget` and `CellsTableWidget`
  * Horizontal and vertical scrolling support for large tables with custom sizes
* **Text Display Improvements:**
  * Fixed text being cut off in cells
  * Auto-scale text to fit cell size using FittedBox
  * Tooltip to show full text when hovering
  * Auto-adjust font size based on cell size
  * Better text overflow handling

## 0.3.0

* **Excel-like Features (NEW!):**
  * Added `CellsDataController` to manage cell data (text, formatting)
  * Added `CellsDataWidget` for editable cells with text editing
  * Added `CellsTableWidget` for displaying data as table
  * Added `CellData` class for cell data and formatting
  * Support loading data from `List<List<String>>` or `List<Map<String, dynamic>>`
  * Support cell formatting (text color, background color, font size, font weight, text alignment)
  * Added search functionality (`CellsSearch`)
  * Added sort functionality (`CellsSort`)
  * Added filter functionality (`CellsFilter`)
  * Added export/import functionality (`CellsExportImport`) - CSV, JSON
  * Support header rows with custom styling
* **Improved Drag Selection:**
  * Fixed drag selection coordinate offset issue using HitTest
  * Improved cell index calculation from touch position
  * More accurate selection when widget is wrapped in containers

## 0.2.2

* **Package Renamed:**
  * Renamed package from `custom_roi_camera_cells` to `custom_roi_cells`
  * Updated all imports and references
  * Updated example app package name to `custom_roi_cells_example`
* **Documentation Improvements:**
  * Added demo section to README.md with screenshots and video support
  * Updated all documentation files to English
  * Added demo images/videos directory structure
  * Improved README.md with visual demonstrations
* **Error Handling:**
  * Added try-catch blocks throughout the library to prevent crashes
  * Improved error handling in CellsController
  * Improved error handling in CellsWidget
  * Added validation for invalid inputs

## 0.2.0

* **Added Selection Feature:**
  * Select cells by tap and drag
  * Highlight selected cells in red
  * Save selection as index array [0,1,2,3,...]
  * Added CellsSelectionButtons widget with Save, Delete, Clear buttons
  * Support selecting cell ranges, rows, and columns
* Improved CellsController with selection methods
* Improved CellsWidget with enableSelection mode
* Updated example app with selection demo

## 0.1.0

* Initial release
* Added CellsWidget to display grid cells
* Added CellsInputWidget with form input
* Added CellsController to manage state
* Support customizable screen size and number of cells
* Support callback when cell is selected
* Support customizable colors, border, and cell number display
