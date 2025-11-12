import 'package:flutter_test/flutter_test.dart';
import 'package:custom_roi_cells/custom_roi_cells.dart';

void main() {
  group('CellsController', () {
    test('khởi tạo với tham số bắt buộc', () {
      final controller = CellsController(
        screenWidth: 2048.0,
        screenHeight: 500.0,
        cellsRows: 32,
        cellsColumns: 23,
      );
      expect(controller.screenWidth, 2048.0);
      expect(controller.screenHeight, 500.0);
      expect(controller.cellsRows, 32);
      expect(controller.cellsColumns, 23);
    });

    test('khởi tạo với tham số tùy chỉnh', () {
      final controller = CellsController(
        screenWidth: 1000.0,
        screenHeight: 500.0,
        cellsRows: 10,
        cellsColumns: 20,
      );
      expect(controller.screenWidth, 1000.0);
      expect(controller.screenHeight, 500.0);
      expect(controller.cellsRows, 10);
      expect(controller.cellsColumns, 20);
    });

    test('tính toán kích thước cell đúng', () {
      final controller = CellsController(
        screenWidth: 1000.0,
        screenHeight: 500.0,
        cellsRows: 10,
        cellsColumns: 20,
      );

      expect(controller.cellWidth, 50.0);
      expect(controller.cellHeight, 50.0);
    });

    test('ném lỗi khi screenWidth <= 0', () {
      expect(
        () => CellsController(
          screenWidth: 0,
          screenHeight: 500.0,
          cellsRows: 32,
          cellsColumns: 23,
        ),
        throwsArgumentError,
      );
      expect(
        () => CellsController(
          screenWidth: -100,
          screenHeight: 500.0,
          cellsRows: 32,
          cellsColumns: 23,
        ),
        throwsArgumentError,
      );
    });

    test('ném lỗi khi screenHeight <= 0', () {
      expect(
        () => CellsController(
          screenWidth: 2048.0,
          screenHeight: 0,
          cellsRows: 32,
          cellsColumns: 23,
        ),
        throwsArgumentError,
      );
    });

    test('ném lỗi khi cellsRows <= 0', () {
      expect(
        () => CellsController(
          screenWidth: 2048.0,
          screenHeight: 500.0,
          cellsRows: 0,
          cellsColumns: 23,
        ),
        throwsArgumentError,
      );
    });

    test('ném lỗi khi cellsColumns <= 0', () {
      expect(
        () => CellsController(
          screenWidth: 2048.0,
          screenHeight: 500.0,
          cellsRows: 32,
          cellsColumns: 0,
        ),
        throwsArgumentError,
      );
    });

    test('cập nhật screenWidth', () {
      final controller = CellsController(
        screenWidth: 2048.0,
        screenHeight: 500.0,
        cellsRows: 32,
        cellsColumns: 23,
      );
      controller.screenWidth = 3000.0;
      expect(controller.screenWidth, 3000.0);
    });

    test('cập nhật screenHeight', () {
      final controller = CellsController(
        screenWidth: 2048.0,
        screenHeight: 500.0,
        cellsRows: 32,
        cellsColumns: 23,
      );
      controller.screenHeight = 800.0;
      expect(controller.screenHeight, 800.0);
    });

    test('cập nhật cellsRows', () {
      final controller = CellsController(
        screenWidth: 2048.0,
        screenHeight: 500.0,
        cellsRows: 32,
        cellsColumns: 23,
      );
      controller.cellsRows = 50;
      expect(controller.cellsRows, 50);
    });

    test('cập nhật cellsColumns', () {
      final controller = CellsController(
        screenWidth: 2048.0,
        screenHeight: 500.0,
        cellsRows: 32,
        cellsColumns: 23,
      );
      controller.cellsColumns = 30;
      expect(controller.cellsColumns, 30);
    });

    test('không cập nhật giá trị âm', () {
      final controller = CellsController(
        screenWidth: 2048.0,
        screenHeight: 500.0,
        cellsRows: 32,
        cellsColumns: 23,
      );
      final originalWidth = controller.screenWidth;
      controller.screenWidth = -100;
      expect(controller.screenWidth, originalWidth);
    });

    test('listener được gọi khi giá trị thay đổi', () {
      final controller = CellsController(
        screenWidth: 2048.0,
        screenHeight: 500.0,
        cellsRows: 32,
        cellsColumns: 23,
      );
      var called = false;
      controller.addListener(() {
        called = true;
      });
      controller.screenWidth = 2000.0;
      expect(called, true);
    });

    test('dispose giải phóng tài nguyên', () {
      final controller = CellsController(
        screenWidth: 2048.0,
        screenHeight: 500.0,
        cellsRows: 32,
        cellsColumns: 23,
      );
      var called = false;
      controller.addListener(() {
        called = true;
      });
      controller.dispose();
      controller.screenWidth = 2000.0;
      expect(called, false);
    });
  });
}
