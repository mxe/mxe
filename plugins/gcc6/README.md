# Notes about GCC version 6.1.0 and later

GCC 6.1 is released with a number of major changes
[[1](https://gcc.gnu.org/ml/gcc-announce/2016/msg00000.html)]
[[2](https://gcc.gnu.org/gcc-6/changes.html)]
. The most notable change is:
> The `C++` frontend now defaults to `C++14` standard instead of `C++98` it has
> been defaulting to previously, for compiling older `C++` code that might
> require either explicitly compiling with selected older `C++` standards,
> or might require some code adjustment, see
> [[3](https://gcc.gnu.org/gcc-6/porting_to.html)]
> for details.

So it is expected that some of MXE packages will fails to build from source
(FTBFS) with default GCC 6.x options. As a workaround we may add `-std=gnu++11`
or `-std=gnu++98` into `CXXFLAGS` for building problematic packages. And this
will not affect the builds with older versions of GCC.

For example, in autotools based projects:
```
...
$(PKG)_CXXFLAGS := -std=gnu++11
...
    cd '$(1)' && \
    CXXFLAGS="$($(PKG)_CXXFLAGS)" \
    ./configure \
...
```

Just after adding this plugin (gcc6) some packages were FTBFS. For now, these
packages might be already fixed by upstream developers, by additional patches
or using above mentioned workaround. See the table below for details. If some
MXE packages or your personal projects are still FTBFS you may look how other
packages were fixed and use similar approach.

Please ensure that proposed fixes for packages also build with earlier GCC
versions [[4](https://github.com/mxe/mxe/commit/a1cc019)].

| package            | target                                  | fixed in commit                                      |
| ------------------ | --------------------------------------- | ---------------------------------------------------- |
| boost              | all                                     | [7ca2bce](https://github.com/mxe/mxe/commit/7ca2bce) |
| cgal               | all                                     | -                                                    |
| dcmtk              | static (all)                            | [8608e13](https://github.com/mxe/mxe/commit/8608e13) |
| fdk-aac            | all                                     | [363aec7](https://github.com/mxe/mxe/commit/363aec7) |
| flann              | all                                     | [73cd813](https://github.com/mxe/mxe/commit/73cd813) |
| freeimage          | static (all)                            | [adc74c9](https://github.com/mxe/mxe/commit/adc74c9) |
| glib               | all                                     | [58c2c96](https://github.com/mxe/mxe/commit/58c2c96) |
| gtkimageview       | static (all)                            | -                                                    |
| gtkmm2             | static (all)                            | -                                                    |
| gtkmm3             | static (all)                            | -                                                    |
| guile              | i686-w64-mingw32.static (all)           | -                                                    |
| itk                | all                                     | [55e9bba](https://github.com/mxe/mxe/commit/55e9bba) |
| jsoncpp            | all                                     | [0bc73f7](https://github.com/mxe/mxe/commit/0bc73f7) |
| json_spirit        | all                                     | -                                                    |
| librsvg            | all                                     | -                                                    |
| libxml++           | all                                     | -                                                    |
| log4cxx            | static (all)                            | -                                                    |
| ocaml-lablgtk2     | i686-w64-mingw32.static (all)           | -                                                    |
| opencv             | all                                     | -                                                    |
| ossim              | all                                     | -                                                    |
| qt                 | all                                     | [5aac1c3](https://github.com/mxe/mxe/commit/5aac1c3) |
| qt3d               | all                                     | [d52961f](https://github.com/mxe/mxe/commit/d52961f) |
| qtwebkit           | i686-w64-mingw32.shared                 | -                                                    |
| sdl_sound          | static (all)                            | -                                                    |
| smpeg              | all                                     | [57cb6bb](https://github.com/mxe/mxe/commit/57cb6bb) |
| smpeg2             | all                                     | [1a42cbc](https://github.com/mxe/mxe/commit/1a42cbc) |
| ucl                | all                                     | [0ac2a77](https://github.com/mxe/mxe/commit/0ac2a77) |
| vtk                | static (all)                            | -                                                    |
| vtk6               | all                                     | -                                                    |
| wxwidgets          | static (all)                            | [6869e3b](https://github.com/mxe/mxe/commit/6869e3b) |
