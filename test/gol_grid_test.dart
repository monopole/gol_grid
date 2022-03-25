import 'package:gol_grid/gol_grid.dart';
import 'package:grid_world/grid_world.dart';
import 'package:test/test.dart';

void main() {
  test('toString', () {
    final grid = GolGrid(DimensionedWorld.make(ConwayEvolver.glider));
    expect(grid.toString(), equals('GolGrid'));
  });

  // testWidgets('TODO add a bloc and test', (tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(GolGrid(GolGridDimensions()));
  //
  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);
  //
  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();
  //
  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });
}
