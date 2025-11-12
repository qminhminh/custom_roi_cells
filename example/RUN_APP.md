# Guide to Run Example App

## Method 1: Run in Android Studio (Recommended)

1. **Open project in Android Studio:**
   - Open Android Studio
   - File → Open → Select `example` folder
   - Or open `custom_roi_cells` folder and select `example` folder in project

2. **Run app:**
   - Select device/emulator from device list
   - Press Run button (▶) or press `Shift + F10`
   - App will be built and run on device/emulator

3. **View interface:**
   - App will display grid cells with selection capability
   - Tap on cells to select/deselect
   - Drag to select multiple cells
   - Use Save, Delete, Clear buttons to manage selection

## Method 2: Run from Terminal/Command Prompt

### Step 1: Install dependencies
```bash
cd example
flutter pub get
```

### Step 2: Check devices
```bash
flutter devices
```

### Step 3: Run app
```bash
flutter run
```

Or run on specific device:
```bash
flutter run -d <device-id>
```

## Method 3: Run on Web (if supported)

```bash
cd example
flutter run -d chrome
```

## Features in Example App

1. **Enter parameters:** Adjust screen size and number of cells
2. **Selection mode:** 
   - Tap to select/deselect a cell
   - Drag to select multiple cells
   - Selected cells will display in red
3. **Control buttons:**
   - **Save:** Save selected index list
   - **Delete:** Delete selected cells
   - **Clear:** Clear all selection
4. **Display result:** Display selected index array as [0,1,2,3,...]

## Notes

- Ensure Flutter SDK is installed
- Ensure device is connected or emulator is started
- If encountering errors, try running `flutter clean` and `flutter pub get` again
