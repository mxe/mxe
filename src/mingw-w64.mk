# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mingw-w64
$(PKG)_WEBSITE  := https://mingw-w64.sourceforge.io/
$(PKG)_DESCR    := MinGW-w64 Runtime
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.0.0
$(PKG)_CHECKSUM := aa20dfff3596f08a7f427aab74315a6cb80c2b086b4a107ed35af02f9496b628
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
