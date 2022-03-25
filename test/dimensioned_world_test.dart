import 'package:test/test.dart';
import 'package:flutter/material.dart';
import 'package:gol_grid/src/dimensioned_world.dart';
import 'package:grid_world/grid_world.dart';

void main() {
  late GridWorld gw;
  late DimensionedWorld dw;

  setUp(() {
    gw = ConwayEvolver.blinker.padBottom(1);
    dw = DimensionedWorld.make(gw, lineWidth: 3, cellWidth: 7);
  });

  test('ctor', () {
    expect(dw.gridWorld, gw);
    expect(dw.gridWorld.toString(), '''
.....
..#..
..#..
..#..
.....
.....
''');
    expect(dw.cellSize, const Size(7, 7));
    expect(dw.gridWorld.nCols, 5);
    expect(dw.gridWorld.nRows, 6);
    //  width: (nCols*(7+3))-3 = 47
    // height: (nRows*(7+3))-3 = 57
    expect(dw.worldSize, const Size(47, 57));
    expect(dw.unusedWidth, 0);
    expect(dw.unusedHeight, 0);
    expect(dw.offset(0), 0);
    expect(dw.offset(1), 10);
    expect(dw.offset(2), 20);
  });

  test('expandToFit', () {
    dw = dw.expandToFit(60, 80);
    expect(dw.gridWorld.toString(), '''
......
......
..#...
..#...
..#...
......
......
......
''');
    expect(dw.cellSize, const Size(7, 7));
    expect(dw.gridWorld.nCols, 6);
    expect(dw.gridWorld.nRows, 8);
    //  width: (nCols*(7+3))-3 = 57
    // height: (nRows*(7+3))-3 = 77
    expect(dw.worldSize, const Size(57, 77));
    // 60-57 = 3
    expect(dw.unusedWidth, 3);
    // 80-77 = 3
    expect(dw.unusedHeight, 3);
    expect(dw.offset(0), 0);
    expect(dw.offset(1), 10);
    expect(dw.offset(2), 20);
  });
}
