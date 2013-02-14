# This file is part of MXE.
# See index.html for further information.

PKG             := openscenegraph
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 3e1b13d17cea0c729389ce440e73ff9d8962e0ae
$(PKG)_SUBDIR   := tonytheodore-$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/tonytheodore/$(PKG)/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc boost curl dcmtk ffmpeg freetype gdal giflib jasper jpeg libpng openal openexr poppler qt tiff xine-lib zlib

define $(PKG)_UPDATE
    echo 'info: sync latest with git svn rebase; git push origin master' >&2;
    $(WGET) -q -O- 'https://github.com/tonytheodore/$(PKG)/commits/master' | \
    $(SED) -n 's#.*<span class="sha">\([^<]\{7\}\)[^<]\{3\}<.*#\1#p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake . \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_CXX_FLAGS=-D__STDC_CONSTANT_MACROS \
        -DCMAKE_HAVE_PTHREAD_H=OFF \
        -DPKG_CONFIG_EXECUTABLE='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        -DDYNAMIC_OPENTHREADS=OFF \
        -DDYNAMIC_OPENSCENEGRAPH=OFF \
        -DBUILD_OSG_APPLICATIONS=OFF \
        -DPOPPLER_HAS_CAIRO_EXITCODE=0 \
        -D_OPENTHREADS_ATOMIC_USE_GCC_BUILTINS_EXITCODE=1
    $(MAKE) -C '$(1)' -j '$(JOBS)' install VERBOSE=1
endef
