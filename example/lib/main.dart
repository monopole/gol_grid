import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gol_grid/gol_grid.dart';
import 'package:grid_world/grid_world.dart';
import 'package:thumper/thumper.dart';
import 'package:tuple/tuple.dart';

// ignore_for_file: diagnostic_describe_all_properties

void main() => runApp(const DemoApp());

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

/// A demo of a single GolGrid widget, either small (on web) or
/// full screen (on android).
@immutable
class OriginalDemoApp extends StatelessWidget {
  /// Make an app instance.
  const OriginalDemoApp({this.isWebDemo = false});

  /// Web or android?
  final bool isWebDemo;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Game of Life Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: OriginalMyScaffold(
            useFullScreen: !isWebDemo, doFancyDemo: !isWebDemo),
      );
}

/// Shows one GolGrid widget, centered,
/// with an AppBar that doesn't do anything yet.
class OriginalMyScaffold extends StatelessWidget {
  const OriginalMyScaffold(
      {this.useFullScreen = true, this.doFancyDemo = true});

  /// A guess as to the media height (virtual pixels) consumed by the AppBar.
  /// TODO: Instead of guessing, look up the appbar via a key, e.g.
  /// medium.com/@diegoveloper/flutter-widget-size-and-position-b0a9ffed9407
  static double get _estimatedAppBarHeight => 82;

  /// Return the width and height of the media available for drawing
  /// in integer GolGrid cell units. Takes AppBar into account.
  static Tuple2<int, int> _sizeAvailableToShowGrid(
      BuildContext c, GolGridDimensions d) {
    final s = MediaQuery.of(c).size;
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

  // An android demo should set both of these true.
  // A web demo is better off doing the opposite.
  final bool useFullScreen;
  final bool doFancyDemo;

  @override
  Widget build(BuildContext c) {
    final dimensions = doFancyDemo
        ? GolGridDimensions()
        : GolGridDimensions(lineWidth: 3, cellWidth: 9);

    /// Could use AppBar hamburger menu to choose this stuff.
    var w = doFancyDemo ? fancyWorld : simpleWorld;
    w = useFullScreen ? _embiggen(c, w, dimensions) : w;
    return BlocProvider(
      create: (context) => ThumperBloc<GridWorld>.fromIterable(
          GridWorldIterable(w, limit: 5000)),
      child: Scaffold(
        backgroundColor: Colors.black26,
        appBar: AppBar(
          title: const Text('game of life'),
          leading: Icon(Icons.menu), // Does nothing at the moment.
        ),
        body: Container(
            color: Colors.black45, child: Center(child: GolGrid(dimensions))),
      ),
    );
  }
}

/// A demo of a single GolGrid widget, either small (on web) or
/// full screen (on android).
@immutable
class DemoApp extends StatelessWidget {
  /// Make an app instance.
  const DemoApp({this.isWebDemo = false});

  /// Web or android?
  final bool isWebDemo;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Game of Life Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            backgroundColor: Colors.red,
            appBar: AppBar(
              title: const Text('Game of Life Demo'),
              leading: Icon(Icons.menu),
            ),
            body: DemoSizingWidget(
              useFullScreen: !isWebDemo,
              doFancyDemo: !isWebDemo,
            )),
      );
}

/// DemoSizingWidget exists only to consult the media (via a MediaQuery)
/// to size various aspects of the demo.  This widget wouldn't be needed
/// if we weren't consulting the media, and instead did a fixed size
/// GridWorld with fixed cell widths.
class DemoSizingWidget extends StatelessWidget {
  /// Make a wrapper with given defaults.
  const DemoSizingWidget({this.useFullScreen = true, this.doFancyDemo = true});

  /// A guess as to the media height (virtual pixels) consumed by the AppBar.
  /// TODO: Instead of guessing, look up the appbar via a key, e.g.
  /// medium.com/@diegoveloper/flutter-widget-size-and-position-b0a9ffed9407
  static double get _estimatedAppBarHeight => 82;

  /// Return the width and height of the media available for drawing
  /// in integer GolGrid cell units. Takes AppBar into account.
  static Tuple2<int, int> _sizeAvailableToShowGrid(
      BuildContext c, GolGridDimensions d) {
    final s = MediaQuery.of(c).size;
    return Tuple2(d.cellCountInWidth(s.width),
        d.cellCountInHeight(s.height - _estimatedAppBarHeight));
  }

  /// Add rows and columns to the world, to give the cellular automata
  /// as much space as possible to maneuver.
  static GridWorld _embiggen(BuildContext c, GridWorld w, GolGridDimensions d) {
    final avail = _sizeAvailableToShowGrid(c, d);
    // This throws if initial world is too big to fit.
    // Could try using ClipRect over an oversized GridWorld.
    return w.expandToFit(avail.item1, avail.item2);
  }

  /// If true, use a more complex GridWorld, and use smaller cell widths.
  final bool doFancyDemo;

  /// If true, try to detect the media and use as much space as possible
  /// by adding empty rows and columns to the GridWorld.
  final bool useFullScreen;

  @override
  Widget build(BuildContext context) {
    final dimensions = doFancyDemo
        ? GolGridDimensions()
        : GolGridDimensions(lineWidth: 3, cellWidth: 9);

    /// Could use AppBar hamburger menu to choose this stuff.
    var w = doFancyDemo ? fancyWorld : simpleWorld;
    w = useFullScreen ? _embiggen(context, w, dimensions) : w;
    return GolGridDemo(dimensions, w);
  }
}

class GolGridDemo extends StatelessWidget {
  final GolGridDimensions _dimensions;
  final GridWorld _w;
  GolGridDemo(this._dimensions, this._w);

  @override
  Widget build(BuildContext c) => BlocProvider(
        create: (context) => ThumperBloc<GridWorld>.fromIterable(
            GridWorldIterable(_w, limit: 5000)),
//    child: Container(
//        color: Colors.black54, child: Center(child: GolGrid(_dimensions))),
    child: Center(child: GolGrid(_dimensions)),
      );
}
