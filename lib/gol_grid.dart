import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grid_world/grid_world.dart';
import 'package:thumper/thumper.dart';

/// GolGrid shows a GridWorld controlled by a Thumper<GridWorld>.
class GolGrid extends StatelessWidget {
  final Color controlsForegroundColor;
  final Color controlsBackgroundColor;
  final Color foregroundColor;
  final Color backgroundColor;

  /// Calculator for this widget.
  final GolGridDimensions _dim;

  /// Returns a widget just big enough to hold the GridWorld passed as an arg.
  /// The world passed as an argument is discarded; it's only used for sizing.
  /// It's assumed that the worlds provided in the state stream from
  /// ThumperBloc<GridWorld> will all have the same size as this argument.
  GolGrid(
    this._dim, {
    this.controlsForegroundColor = Colors.lightGreenAccent,
    this.controlsBackgroundColor = Colors.black54,
    this.foregroundColor = Colors.lightBlueAccent,
    this.backgroundColor = Colors.black,
  });

  Widget build(BuildContext c) =>
      BlocBuilder<ThumperBloc<GridWorld>, ThumperState>(
        condition: (previousState, incomingState) =>
            incomingState.thumpCount != previousState.thumpCount,
        builder: (context, state) {
          return _column(state.thing, _dim.worldSize(state.thing));
        },
      );

  Widget _column(GridWorld gw, Size size) => PreferredSize(
        preferredSize: Size(size.width, size.height + Thumper.height),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _paintedGrid(gw, size),
            Thumper<GridWorld>(onColor: controlsForegroundColor),
          ],
        ),
      );

  Widget _paintedGrid(GridWorld gw, Size size) => CustomPaint(
        foregroundPainter: _CellPainter(gw, _dim, foregroundColor),
        painter: _BackgroundPainter(size, backgroundColor),
        size: size,
      );
}

/// _BackgroundPainter paints what's behind the cells.
/// It's just a solid color; no grid lines.
/// The color should match the color of a dead cell,
/// or we'll be obligated to explicitly draw dead cells.
class _BackgroundPainter extends CustomPainter {
  final Rect _rect;
  final Paint _paint;

  static Paint _makeBackgroundPaint(Color color) {
    return Paint()..color = color;
  }

  _BackgroundPainter(Size s, Color c)
      : _rect = Rect.fromLTRB(0, 0, s.width, s.height),
        _paint = _makeBackgroundPaint(c);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(_rect, _paint);
  }

  /// The painter's properties don't change.
  @override
  bool shouldRepaint(_BackgroundPainter oldPainter) => false;
}

/// Calculates various dimensions.
class GolGridDimensions {
  /// Grid line width in logical pixels.
  final int lineWidth;

  /// Grid cell width in logical pixels.
  final int cellWidth;

  /// Cell size in logical pixels.
  final Size cellSize;

  /// Lets the client see how many Gol cells will fit in a given height, given
  /// the fixed cell, line and control widths used by this widget.
  int cellCountInHeight(double length) =>
      howManyCellsFit(length - Thumper.height);

  /// Like [cellCountInHeight], but for width.
  int cellCountInWidth(double length) => howManyCellsFit(length);

  /// Cells are square.
  static Size _makeCellSize(int w) => Size(w.toDouble(), w.toDouble());

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

  Size worldSize(GridWorld gw) => Size(offset(gw.nCols), offset(gw.nRows));

  double offset(int i) =>
      (lineWidth + (i * (cellWidth + lineWidth))).toDouble();

  GolGridDimensions({this.lineWidth = 1, this.cellWidth = 3})
      : assert(cellWidth > 0 && lineWidth > 0),
        cellSize = _makeCellSize(cellWidth);
}

/// _CellPainter knows how wide cells are, their color,
/// their separation, etc.  It doesn't draw grid lines
/// or dead cells; that's just the background
/// showing through.
class _CellPainter extends CustomPainter {
  final GolGridDimensions _c;
  final GridWorld _gw;
  final Paint _cellPaint;

  /// Cells could presumably be partially transparent too.
  static Paint _makeCellPaint(Color color) {
    return Paint()..color = color;
  }

  _CellPainter(this._gw, this._c, Color foregroundColor)
      : _cellPaint = _makeCellPaint(foregroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < _gw.nRows; i++) {
      for (int j = 0; j < _gw.nCols; j++) {
        if (_gw.isAlive(i, j)) {
          // Only draw live cells; assume dead cell matches background.
          Rect r = Offset(_c.offset(j), _c.offset(i)) & _c.cellSize;
          canvas.drawRect(r, _cellPaint);
        }
      }
    }
  }

  /// The painter's properties don't change.
  @override
  bool shouldRepaint(_CellPainter oldPainter) => false;
}
