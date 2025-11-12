#!/bin/bash

echo "========================================"
echo "Running Custom ROI Camera Cells Example"
echo "========================================"
echo ""

cd "$(dirname "$0")"

echo "Step 1: Installing dependencies..."
flutter pub get
if [ $? -ne 0 ]; then
    echo "Error: Failed to install dependencies"
    exit 1
fi

echo ""
echo "Step 2: Checking available devices..."
flutter devices

echo ""
echo "Step 3: Running app..."
flutter run

