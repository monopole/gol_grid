import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grid_world/grid_world.dart';
import 'package:thumper/thumper.dart';
import 'gol_grid_dimensions.dart';

// ignore_for_file: diagnostic_describe_all_properties

/// GolGrid is a widget showing a GridWorld controlled by a Thumper<GridWorld>.
@immutable
class GolGrid extends StatelessWidget {
  /// Returns a widget sized to its [GolGridDimensions] argument.
  /// It's assumed that the worlds provided in the state stream from
  /// ThumperBloc<GridWorld> will all have matching dimensions (this is
  /// assured if they came from a [GridWorldIterable]).
  const GolGrid(
    this._dim, {
    Key key,
    this.controlsForegroundColor = Colors.lightGreenAccent,
    this.controlsBackgroundColor = Colors.black54,
    this.foregroundColor = Colors.lightBlueAccent,
    this.backgroundColor = Colors.black,
  }) : super(key: key);

  /// Thumper foreground color.
  final Color controlsForegroundColor;

  /// Thumper background color.
  final Color controlsBackgroundColor;

  /// Game of life live cell color.
  final Color foregroundColor;

  /// Game of life dead cell color.
  final Color backgroundColor;

  /// Calculator for this widget.
  final GolGridDimensions _dim;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ThumperBloc<GridWorld>, ThumperState<GridWorld>>(
        condition: (previousState, incomingState) =>
            incomingState.thumpCount != previousState.thumpCount,
        builder: (ctx, state) =>
            _column(state.thing, _dim.worldSize(state.thing)),
      );

  Widget _column(GridWorld gw, Size size) => Container(
        width: size.width,
        height: size.height + Thumper.height,
        color: backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(
              foregroundPainter: _CellPainter(gw, _dim, foregroundColor),
              painter: _BackgroundPainter(size, backgroundColor),
              size: size,
            ),
            Thumper<GridWorld>(onColor: controlsForegroundColor),
          ],
        ),
      );
}

/// _BackgroundPainter paints what's behind the cells.
/// It's just a solid color; no grid lines.
/// The color should match the color of a dead cell,
/// or we'll be obligated to explicitly draw dead cells.
class _BackgroundPainter extends CustomPainter {
  _BackgroundPainter(Size s, Color c)
      : _rect = Rect.fromLTRB(0, 0, s.width, s.height),
        _paint = _makeBackgroundPaint(c);

  final Rect _rect;
  final Paint _paint;

  static Paint _makeBackgroundPaint(Color color) => Paint()..color = color;

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
  _CellPainter(this._gw, this._c, Color foregroundColor)
      : _cellPaint = _makeCellPaint(foregroundColor);

  final GolGridDimensions _c;
  final GridWorld _gw;
  final Paint _cellPaint;

  /// Cells could presumably be partially transparent too.
  static Paint _makeCellPaint(Color color) => Paint()..color = color;

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < _gw.nRows; i++) {
      for (var j = 0; j < _gw.nCols; j++) {
        if (_gw.isAlive(i, j)) {
          // Only draw live cells; assume dead cell matches background.
          final r = Offset(_c.offset(j), _c.offset(i)) & _c.cellSize;
          canvas.drawRect(r, _cellPaint);
        }
      }
    }
  }

  /// The painter's properties don't change.
  @override
  bool shouldRepaint(_CellPainter oldPainter) => false;
}
