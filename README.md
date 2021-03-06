# GolGrid

Conway's [Game of Life] in a flutter widget.

A [`GolGrid`] is a rendering of a [`GridWorld`] controlled by a [`Thumper`].

### Example

The [example] contains two alternatives.

One uses several relatively small widgets in a scrollable column,
suitable for a browser:

[![movie web](https://img.youtube.com/vi/DIPRQGnh4Nc/0.jpg)](https://youtu.be/DIPRQGnh4Nc)

The other does a media query to do a full
screen demo with a complex world (four [Gosper guns]
and an [R-pentomino]), more suitable for android:

[![movie android][android1]](https://youtu.be/x6oBF_giM-s)

To run the examples, install [flutter] (for `demo-web`
demo, use [beta channel flutter]), then

```bash
# Confirm flutter installed and devices available.
flutter devices

# Get the code
git clone git@github.com:monopole/gol_grid.git
cd gol_grid

# then either
make demo-android # needs USB connected device
# or
make demo-web # needs chrome
```


[beta channel flutter]: https://flutter.dev/docs/get-started/web
[`GolGrid`]: https://pub.dev/packages/gol_grid
[`GridWorld`]: https://pub.dev/packages/grid_world
[`Thumper`]: https://pub.dev/packages/thumper
[Game of Life]: https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
[Gosper guns]: https://en.wikipedia.org/wiki/Gun_(cellular_automaton)
[R-pentomino]: https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life#Examples_of_patterns
[spaceship]: https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life#Examples_of_patterns
[example]: example/lib/main.dart
[android1]: images/android1.png
[inVideo]: https://youtu.be/DIPRQGnh4Nc
[inMovie]: images/demo-chrome-at-v0.1.7.mp4
[flutter]: https://flutter.dev/docs/get-started/install
