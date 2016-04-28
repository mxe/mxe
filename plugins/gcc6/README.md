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

Just after adding this plugin (gcc6) some packages were FTBFS:
* boost
* cgal
* dcmtk
* fdk-aac
* fdk-aac
* flann
* freeimage
* glib
* gtkimageview
* gtkmm2
* gtkmm3
* itk
* jsoncpp
* json_spirit
* libical
* librsvg
* libxml++
* log4cxx
* opencv
* ossim
* qt
* qt3d
* sdl_sound
* smpeg2
* ucl
* vtk
* vtk6
* wxwidgets

See logs
[[4](https://gist.github.com/starius/81e25169242155aa3ef6be1a733b9812)]
[[5](https://gist.github.com/c01ef084eeb85781bd1eb7f6b1e12192)]
for details.

For now, these packages might be already fixed by upstream developers, by
additional patches or using above mentioned workaround. If some MXE packages
or your personal projects are still FTBFS you may look how other packages were
fixed and use similar approach.

