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
/// Alternatively, one could show a stack of GolGrids or whatever.
class _MyScaffold extends StatelessWidget {
  static final GridWorld _initialWorld = ConwayEvolver.gunFight()
      .appendBottom(
          ConwayEvolver.rPentimino.padLeft(30).padTop(10).padBottom(10))
      .appendBottom(ConwayEvolver.gunFight())
      .lrPadded(6);

  /// Return integer widths and heights for use in optional expansion
  /// of a world to fill the media available from the context.
  static Tuple2<int, int> _sizeAvailableToShowGrid(BuildContext c) {
    Size s = MediaQuery.of(c).size;
    return Tuple2(GolGrid.cellCountInWidth(s.width),
        GolGrid.cellCountInHeight(s.height - _estimatedAppBarHeight));
  }

  /// There must be a better way to figure out how much of the
  /// media height is consumed by the app bar.
  /// perhaps https://medium.com/@diegoveloper/flutter-widget-size-and-position-b0a9ffed9407
  static double get _estimatedAppBarHeight => 82;

  @override
  Widget build(BuildContext c) {
    var avail = _sizeAvailableToShowGrid(c);
    // This throws if initial world is too big to fit.
    // Could try using clipping to show a window into oversized grids.
    final w = _initialWorld.expandToFit(avail.item1, avail.item2);
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
        //floatingActionButton: _myFab(),
      ),
    );
  }

  Widget _golGrid(GridWorld gw) => GolGrid(
        gw,
        controlsForegroundColor: Colors.lightGreenAccent,
        foregroundColor: Colors.lightBlueAccent,
        backgroundColor: Colors.black,
      );

  Widget _myFab() => FloatingActionButton(
        onPressed: () {},
        tooltip: 'add world?',
        child: Icon(Icons.party_mode),
        // Icon.play  skip_next
      );
}
