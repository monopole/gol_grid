import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gol_grid/gol_grid.dart';
import 'package:grid_world/grid_world.dart';
import 'package:thumper/thumper.dart';
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

/// A GridWorld to display.
final GridWorld fancyWorld = ConwayEvolver.gunFight()
    .appendBottom(ConwayEvolver.rPentimino.padLeft(30).tbPadded(27))
    .appendBottom(ConwayEvolver.gunFight())
    .lrPadded(6);

/// Another world to display
final GridWorld simpleWorld = ConwayEvolver.rPentimino
    .padded(12)
    .appendBottom(ConwayEvolver.lightweightSpaceship)
    .padBottom(1);

/// Shows one GolGrid widget, centered, with an AppBar that doesn't do
/// anything yet.
class _MyScaffold extends StatelessWidget {
  /// A guess as to the media height (virtual pixels) consumed by the AppBar.
  /// TODO: Instead of guessing, look up the appbar via a key, e.g.
  /// medium.com/@diegoveloper/flutter-widget-size-and-position-b0a9ffed9407
  static double get _estimatedAppBarHeight => 82;

  /// Return the width and height of the media available for drawing
  /// in integer GolGrid cell units. Takes AppBar into account.
  static Tuple2<int, int> _sizeAvailableToShowGrid(
      BuildContext c, GolGridDimensions d) {
    Size s = MediaQuery.of(c).size;
    print(MediaQuery.of(c));
    return Tuple2(d.cellCountInWidth(s.width),
        d.cellCountInHeight(s.height - _estimatedAppBarHeight));
  }

  /// Add rows and columns to the world, to give the cellular automata
  /// as much space as possible to maneuver.
  static GridWorld _embiggen(BuildContext c, GridWorld w, GolGridDimensions d) {
    final avail = _sizeAvailableToShowGrid(c, d);
    // This throws if initial world is too big to fit.
    // Could try using clipping to show a window into oversized grids.
    return w.expandToFit(avail.item1, avail.item2);
  }

  // An android demo should set both of these true; a web demo is better
  // off doing the opposite.
  static final bool _useFullScreen = false;
  static final bool _doFancyDemo = false;

  @override
  Widget build(BuildContext c) {
    var dimensions = _doFancyDemo
        ? GolGridDimensions()
        : GolGridDimensions(lineWidth: 3, cellWidth: 9);
    /// Would be nice to have a world choice in-app,
    /// provided by the AppBar hamburger menu or whatever.
    var w = _doFancyDemo ? fancyWorld : simpleWorld;
    w = _useFullScreen ? _embiggen(c, w, dimensions) : w;
    return BlocProvider(
      create: (context) => ThumperBloc<GridWorld>.fromIterable(
          GridWorldIterable(w, limit: 5000)),
      child: Scaffold(
        backgroundColor: Colors.blue.shade100,
        appBar: AppBar(
          title: Text('game of life'),
          leading: Icon(Icons.menu), // Does nothing at the moment.
        ),
        body: Center(child: GolGrid(dimensions)),
      ),
    );
  }
}
