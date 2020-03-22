import 'package:flutter/material.dart';
import 'package:grid_world/grid_world.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thumper/thumper.dart';

/// GolGrid shows a GridWorld controlled by a Thumper<GridWorld>.
class GolGrid extends StatelessWidget {
  /// Lets the client see how many Gol cells will fit in a given height, given
  /// the fixed cell, line and control widths used by this widget.
  static int cellCountInHeight(double length) =>
      _CellPainter.howManyCellsFit(length - Thumper.maxHeight);

  /// Like [_cellCountInHeight], but for width.
  static int cellCountInWidth(double length) =>
      _CellPainter.howManyCellsFit(length);

  final Color controlsForegroundColor;
  final Color controlsBackgroundColor;
  final Color foregroundColor;
  final Color backgroundColor;
  final Size _gwSize;

  /// Returns a widget just big enough to hold the GridWorld passed as an arg.
  /// The world passed as an argument is discarded; it's only used for sizing.
  /// It's assumed that the worlds provided in the state stream from
  /// ThumperBloc<GridWorld> will all have the same size as this argument.
  GolGrid(GridWorld gw,
      {this.controlsForegroundColor = Colors.lightGreenAccent,
      this.controlsBackgroundColor = Colors.black54,
      this.foregroundColor = Colors.lightBlueAccent,
      this.backgroundColor = Colors.black})
      : _gwSize = _CellPainter.worldSize(gw);

  Widget build(BuildContext c) =>
      BlocBuilder<ThumperBloc<GridWorld>, ThumperState>(
        condition: (previousState, incomingState) =>
            incomingState.thumpCount != previousState.thumpCount,
        builder: (context, state) => _column(state.thing),
      );

  Widget _column(GridWorld gw) => PreferredSize(
        preferredSize: Size(_gwSize.width, _gwSize.height + Thumper.maxHeight),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _paintedGrid(gw),
            Thumper<GridWorld>(
                onColor: controlsForegroundColor,
                backgroundColor: controlsBackgroundColor,
                maxWidth: _gwSize.width),
          ],
        ),
      );

  Widget _paintedGrid(GridWorld gw) => CustomPaint(
        foregroundPainter: _CellPainter(gw, foregroundColor),
        painter: _BackgroundPainter(_gwSize, backgroundColor),
        size: _gwSize,
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

/// _CellPainter knows how wide cells are, their color,
/// their separation, etc.  It doesn't draw grid lines
/// or dead cells; that's just the background
/// showing through.
class _CellPainter extends CustomPainter {
  /// Grid line width in logical pixels.
  static final int _lineWidth = 1;

  /// Grid cell width in logical pixels.
  static final int _cellWidth = 3 * _lineWidth;

  /// Cells are square.
  static final Size _cellSize = _makeCellSize(_cellWidth);

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
  static int howManyCellsFit(double length) =>
      ((length + _lineWidth) / (_cellWidth + _lineWidth)).floor();

  static Size worldSize(GridWorld gw) =>
      Size(_offset(gw.nCols), _offset(gw.nRows));

  static double _offset(int i) =>
      (_lineWidth + (i * (_cellWidth + _lineWidth))).toDouble();

  /// Cells could presumably be partially transparent too.
  static Paint _makeCellPaint(Color color) {
    return Paint()..color = color;
  }

  final GridWorld _gw;
  final Paint _cellPaint;

  _CellPainter(GridWorld gw, Color foregroundColor)
      : _gw = gw,
        _cellPaint = _makeCellPaint(foregroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < _gw.nRows; i++) {
      for (int j = 0; j < _gw.nCols; j++) {
        if (_gw.isAlive(i, j)) {
          // Only draw live cells; assume dead cell matches background.
          Rect r = Offset(_offset(j), _offset(i)) & _cellSize;
          canvas.drawRect(r, _cellPaint);
        }
      }
    }
  }

  /// The painter's properties don't change.
  @override
  bool shouldRepaint(_CellPainter oldPainter) => false;
}
