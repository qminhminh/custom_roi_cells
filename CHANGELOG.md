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
