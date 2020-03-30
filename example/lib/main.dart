import 'package:flutter/material.dart';
import 'package:gol_grid/gol_grid.dart';
import 'package:grid_world/grid_world.dart';
import 'package:thumper/thumper.dart';

// ignore_for_file: diagnostic_describe_all_properties
// ignore_for_file: use_key_in_widget_constructors
// ignore_for_file: prefer_const_constructors

void main() => runApp(const DemoApp());

/// A GolGrid widget demo.
@immutable
class DemoApp extends StatelessWidget {
  /// Make an app instance.
  const DemoApp({this.isWebDemo = false});

  /// Web or android?
  final bool isWebDemo;
  static const _spacer = SizedBox(height: 3);

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
            body: isWebDemo ? _manyWidgets() : FullScreenWidget()),
      );

  Widget _manyWidgets() => Center(
        child: ListView(
          children: <Widget>[
            _spacer,
            GolGrid(DimensionedWorld.make(ConwayEvolver.blinker.lrPadded(6),
                lineWidth: 10, cellWidth: 30)),
            _spacer,
            GolGrid(
                DimensionedWorld.make(
                    ConwayEvolver.pentaDecathlon.clockwise90(),
                    lineWidth: 6,
                    cellWidth: 18),
                foregroundColor: Colors.deepPurple),
            _spacer,
            GolGrid(DimensionedWorld.make(
                ConwayEvolver.lightweightSpaceship
                    .appendBottom(ConwayEvolver.lightweightSpaceship)
                    .appendBottom(ConwayEvolver.lightweightSpaceship)
                    .padRight(50),
                lineWidth: 3,
                cellWidth: 9)),
            _spacer,
            GolGrid(
                DimensionedWorld.make(
                    ConwayEvolver.gliderFleet().padRight(20).padBottom(30),
                    lineWidth: 3,
                    cellWidth: 9),
                foregroundColor: Colors.redAccent),
            _spacer,
            GolGrid(DimensionedWorld.make(
                ConwayEvolver.gosperGliderGun.padded(20),
                lineWidth: 3,
                cellWidth: 9)),
            _spacer,
            GolGrid(
                DimensionedWorld.make(
                    ConwayEvolver.rPentimino.lrPadded(70).tbPadded(60),
                    lineWidth: 1,
                    cellWidth: 3),
                foregroundColor: Colors.white),
            _spacer,
          ],
        ),
      );
}

/// [FullScreenWidget] does a MediaQuery to expand a [DimensionedWorld]
/// to fill the media.  The query only works if this widget is below
/// [MaterialApp] in the tree.
class FullScreenWidget extends StatelessWidget {
  /// A guess as to the media height (virtual pixels) consumed by the AppBar.
  /// TODO: Instead of guessing, look up the appbar via a key, e.g.
  /// medium.com/@diegoveloper/flutter-widget-size-and-position-b0a9ffed9407
  static double get _estimatedAppBarHeight => 80; // 80

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    final dw = DimensionedWorld.make(ConwayEvolver.gunFight()
        .appendBottom(ConwayEvolver.rPentimino.padLeft(30).tbPadded(27))
        .appendBottom(ConwayEvolver.gunFight())
        .lrPadded(6));
    return GolGrid(
        dw.expandToFit(
            s.width, s.height - _estimatedAppBarHeight - Thumper.height),
        foregroundColor: Colors.blue);
  }
}
