import 'package:flutter/material.dart';
import 'package:gol_grid/gol_grid.dart';
import 'package:grid_world/grid_world.dart';
import 'package:thumper/thumper.dart';

// ignore_for_file: diagnostic_describe_all_properties
// ignore_for_file: use_key_in_widget_constructors
// ignore_for_file: prefer_const_constructors

void main() => runApp(const DemoApp());

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
            backgroundColor: Colors.grey,
            appBar: AppBar(
              title: const Text('Game of Life Demo'),
              leading: Icon(Icons.menu),
            ),
            body: DemoSizingWidget(isWebDemo: isWebDemo)),
      );
}

/// DemoSizingWidget exists only to consult the media (via a MediaQuery)
/// to size various aspects of the demo.  This widget wouldn't be needed
/// if we weren't consulting the context below a MaterialApp, and instead
/// did a fixed size GridWorld with fixed cell widths.
class DemoSizingWidget extends StatelessWidget {
  /// Make a wrapper with given defaults.
  const DemoSizingWidget({this.isWebDemo = false});

  /// Build a demo for Web or android?
  /// On web, maybe use multiple smaller, simpler widgets.
  /// On Android, maybe use one full screen complex widget.
  final bool isWebDemo;

  @override
  Widget build(BuildContext context) =>
      isWebDemo ? makeWebDemo() : makeAndroidDemo(context);

  /// A guess as to the media height (virtual pixels) consumed by the AppBar.
  /// TODO: Instead of guessing, look up the appbar via a key, e.g.
  /// medium.com/@diegoveloper/flutter-widget-size-and-position-b0a9ffed9407
  static double get _estimatedAppBarHeight => 80; // 81;

  /// One complex widget sized to fill the screen.
  GolGrid makeAndroidDemo(BuildContext context) {
    final s = MediaQuery.of(context).size;
    var dw = DimensionedWorld.make(ConwayEvolver.gunFight()
        .appendBottom(ConwayEvolver.rPentimino.padLeft(30).tbPadded(27))
        .appendBottom(ConwayEvolver.gunFight())
        .lrPadded(6));
    dw = dw.expandToFit(
        s.width, s.height - _estimatedAppBarHeight - Thumper.height);
    return GolGrid(dw);
  }

  /// Demo with fewer total cells in fixed size widgets.
  Widget makeWebDemo() => Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(height: 3),
              GolGrid(DimensionedWorld.make(ConwayEvolver.blinker.lrPadded(6),
                  lineWidth: 6, cellWidth: 18)),
              SizedBox(height: 3),
              GolGrid(DimensionedWorld.make(
                  ConwayEvolver.pentaDecathlon.clockwise90(),
                  lineWidth: 6,
                  cellWidth: 18)),
              SizedBox(height: 3),
              GolGrid(DimensionedWorld.make(
                  ConwayEvolver.lightweightSpaceship
                      .appendBottom(ConwayEvolver.lightweightSpaceship)
                      .appendBottom(ConwayEvolver.lightweightSpaceship)
                      .padRight(50),
                  lineWidth: 3,
                  cellWidth: 9)),
              SizedBox(height: 3),
              GolGrid(DimensionedWorld.make(
                  ConwayEvolver.gliderFleet().padRight(20).padBottom(30),
                  lineWidth: 3,
                  cellWidth: 9)),
              SizedBox(height: 3),
              GolGrid(DimensionedWorld.make(
                  ConwayEvolver.gosperGliderGun.padded(20),
                  lineWidth: 3,
                  cellWidth: 9)),
              SizedBox(height: 3),
              GolGrid(DimensionedWorld.make(ConwayEvolver.rPentimino.padded(50),
                  lineWidth: 1, cellWidth: 3)),
              SizedBox(height: 3),
            ],
          ),
        ),
      );
}
