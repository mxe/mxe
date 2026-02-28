# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := imath
$(PKG)_WEBSITE  := https://github.com/AcademySoftwareFoundation/Imath
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.2
$(PKG)_FILE     := Imath-$($(PKG)_VERSION).tar.gz
$(PKG)_CHECKSUM := b4275d83fb95521510e389b8d13af10298ed5bed1c8e13efd961d91b1105e462
$(PKG)_GH_CONF  := AcademySoftwareFoundation/Imath/tags,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    mkdir -p '$(BUILD_DIR)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DCMAKE_INSTALL_PREFIX='$(PREFIX)/$(TARGET)' \
        -DCMAKE_BUILD_TYPE=Release
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef