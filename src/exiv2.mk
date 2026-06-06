# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := exiv2
$(PKG)_WEBSITE  := https://www.exiv2.org/
$(PKG)_DESCR    := Exiv2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.28.8
$(PKG)_CHECKSUM := ea51b0609f58a9afa063b60daa1539948b62247721e154f4fff0ad3aec9f9756
$(PKG)_GH_CONF  := Exiv2/exiv2/tags,v
$(PKG)_DEPS     := cc brotli expat gettext mman-win32 zlib

define $(PKG)_BUILD
    $(TARGET)-cmake -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DEXIV2_ENABLE_WIN_UNICODE=OFF \
        -DEXIV2_BUILD_SAMPLES=OFF \
        -DEXIV2_ENABLE_INIH=OFF \
        -DCMAKE_CXX_STANDARD_LIBRARIES="-lmman" \
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
