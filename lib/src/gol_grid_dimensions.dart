import 'package:flutter/material.dart';
import 'package:grid_world/grid_world.dart';
import 'package:thumper/thumper.dart';

/// Calculates various dimensions.
@immutable
class GolGridDimensions {
  /// Make the dimensions.
  GolGridDimensions({this.lineWidth = 1, this.cellWidth = 3})
      : assert(cellWidth > 0 && lineWidth > 0, 'nonsense values'),
        cellSize = _makeCellSize(cellWidth);

  /// Grid line width in logical pixels.
  final int lineWidth;

  /// Grid cell width in logical pixels.
  final int cellWidth;

  /// Cell size in logical pixels. Cells are square.
  final Size cellSize;

  /// Cells are square.
  static Size _makeCellSize(int w) => Size(w.toDouble(), w.toDouble());

  /// Lets the client see how many Gol cells will fit in a given height, given
  /// the fixed cell, line and control widths used by this widget.
  int cellCountInHeight(double length) =>
      howManyCellsFit(length - Thumper.height);

  /// Like [cellCountInHeight], but for width.
  int cellCountInWidth(double length) => howManyCellsFit(length);

  /// How many cells can be crammed into the given length?
  /// Takes the line (spacer) between each cell into account.
  ///
  /// Two ways to do this.
  ///
  /// With grid lines on either side of the world:
  ///
  ///  length = ((nCells + 1)*_lineWidth) + (nCells * _cellWidth)
  ///         = (nCells * _lineWidth) + _lineWidth + (nCells * _cellWidth)
  ///  qed: nCells = (length - _lineWidth) / (_lineWidth + _cellWidth)
  ///
  /// No grid lines on either side:
  ///
  ///  length = ((nCells - 1)*_lineWidth) + (nCells * _cellWidth)
  ///         = (nCells * (_lineWidth + _cellWidth)) - _lineWidth
  ///  qed: nCells = (length + _lineWidth) / (_lineWidth + _cellWidth)
  ///
  /// In other case, we have to take the floor.
  int howManyCellsFit(double length) =>
      ((length + lineWidth) / (cellWidth + lineWidth)).floor();

  /// Size of world in logical pixels.
  Size worldSize(GridWorld gw) => Size(offset(gw.nCols), offset(gw.nRows));

  /// Where is (square) cell number i?
  double offset(int i) =>
      (lineWidth + (i * (cellWidth + lineWidth))).toDouble();
}
