### MXE Plugins

MXE lets you override the way packages are built and installed by offering
plugins mechanism. This directory contains a collection of example plugins and
experimental content. Enjoy!

*Note: the files here should be considered examples only and are unmaintained.*

##### Rolling your own plugin

The basic usage is to drop some `*.mk` files in a directory `foo/` and set
`MXE_PLUGIN_DIRS='foo/'` while invoking `make` like this:

```console
MXE_PLUGIN_DIRS=foo/ make libpng
```

If needed, you can also pass multiple directories by separating them with a
space: `MXE_PLUGIN_DIRS='foo1/ foo2/'`. A plugin takes effect only if it is
provided in `MXE_PLUGIN_DIRS`. If you run `make` multiple times, do not
remove a plugin path from `MXE_PLUGIN_DIRS`, otherwise MXE will rebuild
without the plugin. For example, if you want to build qbittorrent from
`apps` plugin with gcc 6 provided by `gcc6` plugin, set `MXE_PLUGIN_DIRS`
to 'plugins/gcc6 plugins/apps' and then run `make qbittorrent`.

For details on `*.mk` contents, please consult the contents of this directory
and `src/*.mk`.
