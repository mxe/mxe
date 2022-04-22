# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := exiv2
$(PKG)_WEBSITE  := https://www.exiv2.org/
$(PKG)_DESCR    := Exiv2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.27.5
$(PKG)_CHECKSUM := 1da1721f84809e4d37b3f106adb18b70b1b0441c860746ce6812bb3df184ed6c
$(PKG)_GH_CONF  := Exiv2/exiv2/tags,v
$(PKG)_DEPS     := cc expat gettext mman-win32 zlib

define $(PKG)_BUILD
    $(TARGET)-cmake -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DEXIV2_BUILD_SAMPLES=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
