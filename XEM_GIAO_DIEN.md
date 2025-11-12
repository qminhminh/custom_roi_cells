# 👀 VIEW INTERFACE AND TEST FUNCTIONALITY

## 🎯 OBJECTIVE
View app interface and test all coded functionality

---

## 📋 FUNCTIONALITY CHECKLIST

### 1. ✅ Basic Interface
- [ ] App opens
- [ ] Header displays correctly
- [ ] Grid cells display 15x15
- [ ] Save, Delete, Clear buttons display

### 2. ✅ Selection Functionality
- [ ] Tap on cell → Cell turns red
- [ ] Tap again → Cell deselects (returns to white)
- [ ] Drag from one cell to another → Select range
- [ ] Drag diagonally → Select rectangle

### 3. ✅ Result Display
- [ ] Select cells → Display count
- [ ] Select cells → Display index list
- [ ] Select cells → Display JSON array: `[0,1,2,3,...]`

### 4. ✅ Control Buttons
- [ ] Press Save → Save selection and display array
- [ ] Press Delete → Delete selected cells
- [ ] Press Clear → Clear all selection

---

## 🎨 INTERFACE DESCRIPTION

### Colors:
- **Header**: Light blue (#E3F2FD)
- **Grid background**: White
- **Unselected cells**: White
- **Selected cells**: Red (70% opacity)
- **Cell borders**: Light blue (#90CAF9)
- **Save button**: Blue (#2196F3)
- **Delete button**: Black (#424242)
- **Clear button**: Gray (#9E9E9E)

### Sizes:
- **Grid**: 600px x 400px
- **Cells**: ~40px x ~27px (auto-calculated)
- **Border**: 0.5px

---

## 🧪 TEST CASES

### Test 1: Select one cell
```
1. Tap on cell at position (0,0) - index 0
2. Expected: Cell turns red
3. Check: selectedIndices = [0]
```

### Test 2: Select multiple individual cells
```
1. Tap on cell 0
2. Tap on cell 5
3. Tap on cell 10
4. Expected: 3 red cells
5. Check: selectedIndices = [0, 5, 10]
```

### Test 3: Drag to select range
```
1. Press and hold cell 20
2. Drag to cell 25
3. Expected: Cells 20-25 all red
4. Check: selectedIndices = [20, 21, 22, 23, 24, 25]
```

### Test 4: Select rectangle
```
1. Press and hold cell 30 (row 2, column 0)
2. Drag to cell 45 (row 3, column 0)
3. Expected: Select both row 2 and row 3
4. Check: selectedIndices contains cells from 30-44
```

### Test 5: Save selection
```
1. Select some cells
2. Press Save button
3. Expected: Display SnackBar "✅ Saved X cells"
4. Check: Index array displays correctly
```

### Test 6: Delete selection
```
1. Select some cells
2. Press Delete button
3. Expected: Cells deselect, display SnackBar
4. Check: selectedIndices = []
```

### Test 7: Clear selection
```
1. Select multiple cells
2. Press Clear button
3. Expected: All cells deselect
4. Check: selectedIndices = []
```

---

## 📸 SCREENSHOT DESCRIPTION

### Main screen:
```
┌──────────────────────────────────────┐
│  Custom ROI Camera Cells        [×]  │
├──────────────────────────────────────┤
│                                      │
│  ┌────────────────────────────────┐ │
│  │ 📱 Custom ROI Camera Cells     │ │
│  │ • Tap to select/deselect a cell│ │
│  │ • Drag to select multiple cells│ │
│  │ • Selected cells will display  │ │
│  │   in red                       │ │
│  └────────────────────────────────┘ │
│                                      │
│  Grid Cells (15x15):                │
│  ┌──────────────────────────────┐   │
│  │ ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ │   │
│  │ ⬜🔴🔴🔴⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ │   │
│  │ ⬜🔴🔴🔴⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ │   │
│  │ ⬜🔴🔴🔴⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ │   │
│  │ ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ │   │
│  │ ... (15 rows x 15 columns)      │   │
│  └──────────────────────────────┘   │
│                                      │
│  [Save]  [Delete]  [Clear]          │
│                                      │
│  ✅ Selected 9 cells:                │
│  List: 16, 17, 18, 31, 32, ...      │
│  Array: [16,17,18,31,32,33,46,47,48]│
│                                      │
└──────────────────────────────────────┘
```

### When selecting cells:
- Selected cells: Red (🔴)
- Unselected cells: White (⬜)
- Border: Light blue

---

## 🚀 QUICK RUN METHOD

### Option 1: Android Studio (Recommended)
1. Open Android Studio
2. File → Open → `example`
3. Press Run (▶)

### Option 2: Automatic Script
```bash
# Windows
cd example
CHAY_NHANH.bat

# Mac/Linux
cd example
chmod +x run.sh
./run.sh
```

### Option 3: Terminal
```bash
cd example
flutter pub get
flutter run
```

---

## ✅ EXPECTED RESULTS

After running the app, you will see:

1. ✅ Beautiful, modern interface
2. ✅ Clear 15x15 grid cells
3. ✅ Smooth tap and drag operation
4. ✅ Selected cells display in red
5. ✅ Control buttons work correctly
6. ✅ Index array displays accurately

---

## 🐛 TROUBLESHOOTING

### App won't run
→ Open Android Studio and run from there

### No device found
→ Create emulator in Android Studio

### Build failed
→ Run `flutter clean` and `flutter pub get`

### Cells can't be selected
→ Check `enableSelection: true` in code

---

**Good luck with testing! 🎉**
