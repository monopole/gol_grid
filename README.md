# GolGrid

A `GolGrid` is a flutter widget showing
a [`GridWorld`] controlled by a [`Thumper`].

I.e. it's Conway's [Game of Life] in a flutter widget.
The widget iterates through evolutionary steps of
a given world via the `Thumper`.

### Example

The [example] iterates through steps in
a world with a lightweight [spaceship]
cruising below an [R-pentomino].


| initial                 | playing                 |
| ----------------------- | ----------------------- |
| ![screen shot 1][shot1] | ![screen shot 2][shot2] |


To run it, install [flutter] then:

```bash
git clone git@github.com:monopole/gol_grid.git
cd gol_grid/example
flutter -d web run
```

[`GridWorld`]: https://pub.dev/packages/grid_world
[`Thumper`]: https://pub.dev/packages/thumper
[Game of Life]: https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
[R-pentomino]: https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life#Examples_of_patterns
[spaceship]: https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life#Examples_of_patterns
[example]: ./example/lib/main.dart
[shot1]: ./images/shot1.png
[shot2]: ./images/shot2.png
[flutter]: https://flutter.dev/docs/get-started/install
