# GolGrid

A [`GolGrid`] is a flutter widget showing
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

Install [flutter] (for chrome demo, use [beta channel flutter]), then

```bash
# Confirm you have some devices.
flutter devices

# Get the code
git clone git@github.com:monopole/gol_grid.git
cd gol_grid

# then either
make demo-chrome
# or
make demo-android
```

[beta channel flutter]: https://flutter.dev/docs/get-started/web
[`GolGrid`]: https://pub.dev/packages/gol_grid
[`GridWorld`]: https://pub.dev/packages/grid_world
[`Thumper`]: https://pub.dev/packages/thumper
[Game of Life]: https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
[R-pentomino]: https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life#Examples_of_patterns
[spaceship]: https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life#Examples_of_patterns
[example]: ./example/lib/main.dart
[shot1]: ./images/shot1.png
[shot2]: ./images/shot2.png
[flutter]: https://flutter.dev/docs/get-started/install
