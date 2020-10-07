# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := jasper
$(PKG)_WEBSITE  := https://www.ece.uvic.ca/~mdadams/jasper/
$(PKG)_DESCR    := JasPer
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.22
$(PKG)_CHECKSUM := afc4166bff29b8a0dc46ed5e8d6a208d7976fccfd0b1146e3400c8b2948794a2
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
