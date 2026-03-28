# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mingw-w64
$(PKG)_WEBSITE  := https://mingw-w64.sourceforge.io/
$(PKG)_DESCR    := MinGW-w64 Runtime
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 14.0.0
$(PKG)_CHECKSUM := 6eaf921d9eb987d3820b364ea9775bc19b965ec81490b6fdd716526c28e1995c
$(PKG)_SUBDIR   := $(PKG)-v$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-v$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(PKG)-release/$($(PKG)_FILE)
$(PKG)_TYPE     := script
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/' | \
    $(SED) -n 's,.*mingw-w64-v\([0-9.]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

# can't install headers here since dummy pthreads headers are installed
# and then clobbered by inline winpthreads build in gcc (see #958)

define $(PKG)_BUILD
    # create pkg-config files for OpenGL/GLU
    mkdir -p '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: gl'; \
     echo 'Version: 0'; \
     echo 'Description: OpenGL'; \
     echo 'Libs: -lopengl32';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/gl.pc'

    (echo 'Name: glu'; \
     echo 'Version: 0'; \
     echo 'Description: OpenGL'; \
     echo 'Libs: -lglu32';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/glu.pc'
endef
