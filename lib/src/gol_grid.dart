import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grid_world/grid_world.dart';
import 'package:thumper/thumper.dart';
import 'dimensioned_world.dart';

// ignore_for_file: diagnostic_describe_all_properties

/// GolGrid is a widget showing a GridWorld controlled by a Thumper<GridWorld>.
@immutable
class GolGrid extends StatelessWidget {
  /// Returns a widget sized to its [DimensionedWorld] argument.
  /// It's assumed that the worlds provided in the state stream from
  /// ThumperBloc<GridWorld> will all have matching dimensions (this is
  /// assured if they came from a [GridWorldIterable]).
  const GolGrid(
    this._dimensions, {
    Key key,
    this.foregroundColor = Colors.lightBlueAccent,
    this.backgroundColor = Colors.black,
    this.controlsForegroundColor = Colors.lightGreenAccent,
    this.controlsBackgroundColor = Colors.black,
    this.hardIterationLimit = 10000,
  }) : super(key: key);

  /// [GridWorld] plus dimensions associated with rendering.
  final DimensionedWorld _dimensions;

  /// Game of life live cell color.
  final Color foregroundColor;

  /// Game of life dead cell color.
  final Color backgroundColor;

  /// Thumper foreground color.
  final Color controlsForegroundColor;

  /// Thumper background color.
  final Color controlsBackgroundColor;

  /// When this limit is hit, automatically halt iteration.
  /// No way to continue - must reset and start over.
  /// This is nothing more than energy conservation.
  final int hardIterationLimit;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => ThumperBloc<GridWorld>.fromIterable(
            GridWorldIterable(_dimensions.gridWorld,
                limit: hardIterationLimit)),
        child: BlocBuilder<ThumperBloc<GridWorld>, ThumperState<GridWorld>>(
          condition: (previousState, incomingState) =>
              incomingState.thumpCount != previousState.thumpCount,
          builder: (ctx, state) => _column(state.thing),
        ),
      );

  Widget _column(GridWorld gw) => Container(
        width: _dimensions.worldSize.width + _dimensions.unusedWidth,
        height: _dimensions.worldSize.height +
            _dimensions.unusedHeight +
            Thumper.height,
        color: backgroundColor,
        padding: EdgeInsets.only(
            left: _dimensions.unusedWidth / 2,
            right: _dimensions.unusedWidth / 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(
              foregroundPainter: _CellPainter(gw, _dimensions, foregroundColor),
              //painter:
              //    _BackgroundPainter(_dimensions.worldSize, backgroundColor),
              size: _dimensions.worldSize,
            ),
            SizedBox(height: _dimensions.unusedHeight),
            Container(
                color: controlsBackgroundColor,
                child: Thumper<GridWorld>(onColor: controlsForegroundColor)),
          ],
        ),
      );
}

// _BackgroundPainter paints what's behind the cells.
// Could use this to, say, draw fancy throbbing grid lines,
// recently dead cell animations, etc.
// Not using this because if the background is just a solid color,
// the widget can just rely on the encapsulating [Container]'s color.
// The [Container] color should match the color of a dead cell,
// or we'll be obligated to explicitly draw dead cells, which
// doesn't happen at the time of writing.
// ignore: unused_element
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
  _CellPainter(this._gw, this._dw, Color foregroundColor)
      : _cellPaint = _makeCellPaint(foregroundColor);

  // Used to set dimensions.
  final DimensionedWorld _dw;
  // Has changing cells, but fixed dimensions.
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
          final r = Offset(_dw.offset(j), _dw.offset(i)) & _dw.cellSize;
          canvas.drawRect(r, _cellPaint);
        }
      }
    }
  }

  /// The painter's properties don't change.
  @override
  bool shouldRepaint(_CellPainter oldPainter) => false;
}
