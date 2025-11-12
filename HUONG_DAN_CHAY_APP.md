# 🚀 Guide to Run Example App

## Method 1: Run in Android Studio (Recommended - Easiest) ⭐

### Step 1: Open project
1. Open **Android Studio**
2. Select **File → Open**
3. Select the **`example`** folder in this project
   - Path: `custom_roi_camera_cells/example`

### Step 2: Wait for Android Studio to sync
- Android Studio will automatically sync dependencies
- Wait until sync completes (usually takes 1-2 minutes)

### Step 3: Select device
- Select device/emulator from dropdown at the top
- Or connect Android phone and enable USB Debugging
- Or create a new Android Emulator

### Step 4: Run app
- Press the **Run** button (▶) in green at the top
- Or press **Shift + F10**
- App will be built and run automatically

### Step 5: View interface
- App will display 15x15 grid cells
- **Tap** on cells to select (red color)
- **Drag** to select multiple cells
- Use **Save**, **Delete**, **Clear** buttons to manage

---

## Method 2: Run from Terminal (If Flutter is installed)

### Windows (PowerShell or CMD):
```powershell
cd example
flutter pub get
flutter run
```

### Mac/Linux:
```bash
cd example
flutter pub get
flutter run
```

---

## Method 3: Run on Web (If supported)

```bash
cd example
flutter run -d chrome
```

---

## 📱 Interface will display:

1. **Header**: Usage instructions
2. **Grid Cells**: 15x15 grid with selection capability
3. **Control buttons**: Save, Delete, Clear
4. **Result**: Display selected index list as array `[0,1,2,3,...]`

## ✨ Features:

- ✅ Tap to select/deselect a cell
- ✅ Drag to select multiple cells
- ✅ Selected cells display in red
- ✅ Save selection as index array
- ✅ Delete selection
- ✅ Display result as JSON array

## 🔧 Requirements:

- Android Studio (or VS Code with Flutter extension)
- Flutter SDK installed
- Android Emulator or real Android device
- Device/emulator connected

## ❓ Troubleshooting?

1. **Error "Flutter not found"**:
   - Ensure Flutter SDK is installed
   - Add Flutter to PATH

2. **Error "No devices found"**:
   - Start Android Emulator
   - Or connect phone and enable USB Debugging

3. **Build error**:
   - Run `flutter clean`
   - Run `flutter pub get` again
   - Delete `.dart_tool` and `build` folders

---

## 📸 Screenshots:

After running the app, you will see:
- Grid cells with blue border
- Selected cells will be red
- Save, Delete, Clear buttons at bottom
- Display selected index array

**Good luck! 🎉**
