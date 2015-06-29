# This file is part of MXE.
# See index.html for further information.

PKG             := box2d
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.0
$(PKG)_CHECKSUM := 1d3ea1f872b3cab3ef5130a2404d74f9ff66f265
$(PKG)_SUBDIR   := Box2D_v$($(PKG)_VERSION)/Box2D
$(PKG)_FILE     := Box2D_v$($(PKG)_VERSION).7z
$(PKG)_URL      := https://box2d.googlecode.com/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://code.google.com/b/box2d/downloads/list?sort=-uploaded' | \
    $(SED) -n 's,.*Box2D_v\([0-9][^<]*\)\.7z.*,\1,p' | \
    grep -v 'rc' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake . \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBOX2D_INSTALL=ON \
        -DBOX2D_BUILD_EXAMPLES=OFF \
        $(if $(BUILD_SHARED), \
            -DBOX2D_BUILD_SHARED=TRUE \
            -DBOX2D_BUILD_STATIC=FALSE, \
            -DBOX2D_BUILD_SHARED=FALSE) \
        '$(1)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' install VERBOSE=1
endef
