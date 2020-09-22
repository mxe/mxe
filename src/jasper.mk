# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := jasper
$(PKG)_WEBSITE  := https://www.ece.uvic.ca/~mdadams/jasper/
$(PKG)_DESCR    := JasPer
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.21
$(PKG)_CHECKSUM := 2482def06dfaa33b8d93cbe992a29723309f3c2b6e75674423a52fc82be10418
$(PKG)_GH_CONF  := mdadams/jasper/tags, version-
$(PKG)_DEPS     := cc jpeg

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DJAS_ENABLE_SHARED=$(CMAKE_SHARED_BOOL) \
        -DJAS_ENABLE_LIBJPEG=ON \
        -DJAS_ENABLE_OPENGL=OFF \
        -DJAS_ENABLE_AUTOMATIC_DEPENDENCIES=OFF \
        -DJAS_ENABLE_DOC=OFF \
        -DJAS_ENABLE_PROGRAMS=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
