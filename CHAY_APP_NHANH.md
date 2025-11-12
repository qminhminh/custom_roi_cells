# 🚀 QUICK RUN APP - VIEW INTERFACE

## ⚡ FASTEST METHOD (3 steps)

### Step 1: Open Android Studio
- Open Android Studio
- **File → Open** → Select `example` folder

### Step 2: Select Device
- At the top bar, select device (emulator or phone)
- If not available, create emulator: **Tools → Device Manager → Create Device**

### Step 3: Run
- Press **▶ Run** button (green) or press **Shift + F10**
- Wait for app to build and run (1-2 minutes first time)

---

## 📱 INTERFACE WILL DISPLAY:

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

---

## ✨ HOW TO USE:

1. **Tap on cell**: Select/deselect (red = selected)
2. **Drag mouse/finger**: Select multiple cells at once
3. **Save button**: Save selected index list
4. **Delete button**: Delete selected cells
5. **Clear button**: Clear all selection

---

## 🎯 FUNCTIONALITY TEST:

### ✅ Test 1: Tap to select
- Tap on any cell
- Cell will turn red
- Tap again to deselect

### ✅ Test 2: Drag to select
- Press and hold mouse/finger on a cell
- Drag to other cells
- All cells in drag range will be selected

### ✅ Test 3: Save selection
- Select some cells
- Press **Save** button
- View index array displayed below: `[0,1,2,3,...]`

### ✅ Test 4: Delete selection
- Select some cells
- Press **Delete** or **Clear** button
- Cells will be deselected

---

## 🐛 IF YOU ENCOUNTER ERRORS:

### Error: "Flutter not found"
```bash
# Check if Flutter is installed
flutter --version

# If not, install Flutter from:
# https://flutter.dev/docs/get-started/install
```

### Error: "No devices found"
1. Open Android Studio
2. **Tools → Device Manager**
3. Create new emulator or connect phone

### Error: "Build failed"
```bash
cd example
flutter clean
flutter pub get
flutter run
```

---

## 📸 DETAILED INTERFACE DESCRIPTION:

### 1. **Header (Light blue)**
- Title: "📱 Custom ROI Camera Cells"
- Usage instructions in 3 lines

### 2. **Grid Cells (White with blue border)**
- 15 rows x 15 columns grid
- Total of 225 cells
- Unselected cells: white
- Selected cells: red (70% opacity)
- Border: light blue

### 3. **Control Buttons**
- **Save** (blue): Save selection
- **Delete** (black): Delete selection
- **Clear** (gray): Clear all

### 4. **Result (Light blue)**
- Number of selected cells
- Index list
- JSON array: `[0,1,2,3,...]`

---

## 🎬 VIDEO GUIDE (Description):

1. Open app → See 15x15 grid
2. Tap on first cell → Cell turns red
3. Tap on cells 2, 3, 4 → Multiple red cells
4. Drag from cell 10 to cell 20 → Select range
5. Press Save → See array `[10,11,12,...,20]`
6. Press Clear → All cells return to white

---

## 💡 TIPS:

- **Zoom**: Pinch to zoom (on mobile)
- **Scroll**: Drag to scroll (if grid is large)
- **Multiple selection**: Can tap multiple times to select individual cells
- **Range selection**: Drag to select an area

---

## ✅ CHECKLIST:

- [ ] App runs
- [ ] Grid displays correctly 15x15
- [ ] Tap selects cell
- [ ] Drag selects multiple cells
- [ ] Selected cells display in red
- [ ] Save button works
- [ ] Delete button works
- [ ] Clear button works
- [ ] Index array displays correctly

---

**Good luck! 🎉**
