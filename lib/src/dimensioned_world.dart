import 'package:flutter/material.dart';
import 'package:grid_world/grid_world.dart';

/// [DimensionedWorld] holds lengths in units logical pixels associated
/// with rendering a [GridWorld].
///
/// E.g. the size of a cell, the distance between cells in pixels,
/// the size of the entire world rendered in pixels.
///
/// [DimensionedWorld] stores the [GridWorld] too, making it possible
/// to offer the [DimensionedWorld.expandToFit] method.
@immutable
class DimensionedWorld {
  /// Make a DimensionedWorld.
  factory DimensionedWorld.make(GridWorld w,
      {int lineWidth = 1, int cellWidth = 3}) {
    assert(cellWidth > 0, 'cellWidth must be > zero');
    assert(lineWidth > 0, 'lineWidth must be > zero');
    final cellSize = _makeCellSize(cellWidth);
    // worldSize gets used a lot, so caching it as a precomputed Size.
    final worldSize = _makeWorldSize(w, lineWidth, cellWidth);
    return DimensionedWorld._(
      w,
      lineWidth,
      cellWidth,
      cellSize,
      worldSize,
    );
  }

  /// Private constructor that accepts vetted arguments for caching.
  const DimensionedWorld._(this.gridWorld, this._lineWidth, this._cellWidth,
      this.cellSize, this.worldSize,
      {this.unusedWidth = 0, this.unusedHeight = 0})
      : assert(unusedWidth >= 0, 'unusedWidth must be >= 0'),
        assert(unusedHeight >= 0, 'unusedWidth must be >= 0');

  /// The world to be rendered.
  final GridWorld gridWorld;

  /// Grid line width in logical pixels.
  final int _lineWidth;

  /// Grid cell width in logical pixels.
  final int _cellWidth;

  /// Cell size in logical pixels. Cells are square.
  final Size cellSize;

  /// World size in logical pixels. Worlds are rectangular.
  final Size worldSize;

  /// Width left over from [expandToFit].
  final double unusedWidth;

  /// Height left over from [expandToFit].
  final double unusedHeight;

  /// Cells are square.
  static Size _makeCellSize(int w) => Size(w.toDouble(), w.toDouble());

  /// Worlds are rectangular.
  /// This offers width and height of a grid of cells
  /// with no lines on the borders, only in between cells.
  static Size _makeWorldSize(GridWorld gw, int lW, int cW) =>
      Size(_offset(gw.nCols, lW, cW) - lW, _offset(gw.nRows, lW, cW) - lW);

  /// Where is the left, top corner of (square) cell number i?
  double offset(int i) => _offset(i, _lineWidth, _cellWidth);

  /// This means no grid lines on borders.
  static double _offset(int i, int lW, int cW) => (i * (cW + lW)).toDouble();

  /// How many (discrete, complete) cells can be crammed into the given length?
  /// Takes the line (spacer) between each cell into account.
  ///
  /// Two ways to do this.
  ///
  /// With grid lines on all sides of the world:
  ///
  ///  length = ((nCells + 1)*_lineWidth) + (nCells * _cellWidth)
  ///         = (nCells * _lineWidth) + _lineWidth + (nCells * _cellWidth)
  ///  qed: nCells = (length - _lineWidth) / (_lineWidth + _cellWidth)
  ///
  /// With no grid lines on the sides:
  ///
  ///  length = ((nCells - 1)*_lineWidth) + (nCells * _cellWidth)
  ///         = (nCells * (_lineWidth + _cellWidth)) - _lineWidth
  ///  qed: nCells = (length + _lineWidth) / (_lineWidth + _cellWidth)
  ///
  /// Must take the floor() since we cannot allow fractional cells.
  int _howManyCellsFit(double length) =>
      ((length + _lineWidth) / (_lineWidth + _cellWidth)).floor();

  /// Add rows and columns to the world, to give the automata
  /// as much space as possible to maneuver.
  /// This throws if the underlying [GridWorld] is already too
  /// big to fit into the new width and height.
  /// Could try using ClipRect over an oversized GridWorld.
  DimensionedWorld expandToFit(double width, double height) {
    final gw = gridWorld.expandToFit(
        _howManyCellsFit(width), _howManyCellsFit(height));
    final wSize = _makeWorldSize(gw, _lineWidth, _cellWidth);
    return DimensionedWorld._(gw, _lineWidth, _cellWidth, cellSize, wSize,
        unusedWidth: width - wSize.width, unusedHeight: height - wSize.height);
  }
}
