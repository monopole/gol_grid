import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grid_world/grid_world.dart';
import 'package:thumper/thumper.dart';
import 'package:gol_grid/gol_grid.dart';
import 'package:tuple/tuple.dart';

void main() => runApp(GolApp());

class GolApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Game of Life Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: _MyScaffold(),
      );
}

/// _MyScaffold makes a GridWorld, then tries to expand it to fit into
/// the current media to make a single GolGrid to fill the screen.
///
/// Alternatively, one could show a stack of GolGrids or whatever.
class _MyScaffold extends StatelessWidget {

  /// A GridWorld to display.
  /// Would be nice to have a choice in-app,
  /// provided by the AppBar hamburger menu or whatever.
  static final GridWorld _initialWorld = ConwayEvolver.gunFight()
      .appendBottom(
          ConwayEvolver.rPentimino.padLeft(30).padTop(10).padBottom(10))
      .appendBottom(ConwayEvolver.gunFight())
      .lrPadded(6);

  /// A guess as to the media height (virtual pixels) consumed by the AppBar.
  /// Needed to size the GridWorld to take up the viewable area.
  /// TODO: Instead of guessing, look up the appbar via a key, e.g.
  /// medium.com/@diegoveloper/flutter-widget-size-and-position-b0a9ffed9407
  static double get _estimatedAppBarHeight => 82;

  /// Return integer widths and heights for use in optional expansion
  /// of a world to fill the media available from the context.
  static Tuple2<int, int> _sizeAvailableToShowGrid(BuildContext c) {
    Size s = MediaQuery.of(c).size;
    return Tuple2(GolGrid.cellCountInWidth(s.width),
        GolGrid.cellCountInHeight(s.height - _estimatedAppBarHeight));
  }

  static GridWorld _embiggen(BuildContext c, GridWorld w) {
    final avail = _sizeAvailableToShowGrid(c);
    // This throws if initial world is too big to fit.
    // Could try using clipping to show a window into oversized grids.
    return _initialWorld.expandToFit(avail.item1, avail.item2);
  }

  static final bool _useFullScreen = true;

  @override
  Widget build(BuildContext c) {
    final w = _useFullScreen ? _embiggen(c, _initialWorld) : _initialWorld;
    return BlocProvider(
      create: (context) => ThumperBloc<GridWorld>.fromIterable(
          GridWorldIterable(w, limit: 5000)),
      child: Scaffold(
        backgroundColor: Colors.blue.shade100,
        appBar: AppBar(
          title: Text('game of life'),
          leading: Icon(Icons.menu),
        ),
        body: Center(child: _golGrid(w)),
      ),
    );
  }

  Widget _golGrid(GridWorld gw) => GolGrid(
        gw,
        controlsForegroundColor: Colors.lightGreenAccent,
        foregroundColor: Colors.lightBlueAccent,
        backgroundColor: Colors.black,
      );
}
