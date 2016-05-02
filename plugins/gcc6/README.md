# Notes about GCC version 6.1.0 and later

GCC 6.1 is released with a number of major changes
[[1](https://gcc.gnu.org/ml/gcc-announce/2016/msg00000.html)]
[[2](https://gcc.gnu.org/gcc-6/changes.html)]
. The most notable change is:
> The `C++` frontend now defaults to `C++14` standard instead of `C++98` it has
> been defaulting to previously, for compiling older `C++` code that might
> require either explicitly compiling with selected older `C++` standards,
> or might require some code adjustment, see
> [[3](http://gcc.gnu.org/gcc-6/porting_to.html)]
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

| package            | target                                  | fixed in commit                                      |
| ------------------ | --------------------------------------- | ---------------------------------------------------- |
| boost              | all                                     | [7ca2bce](https://github.com/mxe/mxe/commit/7ca2bce) |
| cgal               | all                                     | -                                                    |
| dcmtk              | all                                     | -                                                    |
| fdk-aac            | all                                     | -                                                    |
| flann              | all                                     | -                                                    |
| freeimage          | all                                     | -                                                    |
| glib               | all                                     | [58c2c96](https://github.com/mxe/mxe/commit/58c2c96) |
| gtkimageview       | all                                     | -                                                    |
| gtkmm2             | all                                     | -                                                    |
| gtkmm3             | all                                     | -                                                    |
| guile              | i686-w64-mingw32.static (all)           | -                                                    |
| itk                | all                                     | -                                                    |
| jsoncpp            | all                                     | [0bc73f7](https://github.com/mxe/mxe/commit/0bc73f7) |
| json_spirit        | all                                     | -                                                    |
| librsvg            | all                                     | -                                                    |
| libxml++           | all                                     | -                                                    |
| log4cxx            | all                                     | -                                                    |
| ocaml-lablgtk2     | i686-w64-mingw32.static (all)           | -                                                    |
| opencv             | all                                     | -                                                    |
| ossim              | all                                     | -                                                    |
| qt                 | all                                     | [5aac1c3](https://github.com/mxe/mxe/commit/5aac1c3) |
| qt3d               | all                                     | -                                                    |
| qtwebkit           | i686-w64-mingw32.shared                 | -                                                    |
| sdl_sound          | all                                     | -                                                    |
| smpeg              | all                                     | [57cb6bb](https://github.com/mxe/mxe/commit/57cb6bb) |
| smpeg2             | all                                     | [1a42cbc](https://github.com/mxe/mxe/commit/1a42cbc) |
| ucl                | all                                     | -                                                    |
| vtk                | all                                     | -                                                    |
| vtk6               | all                                     | -                                                    |
| wxwidgets          | all                                     | -                                                    |
