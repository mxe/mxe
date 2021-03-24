# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := exiv2
$(PKG)_WEBSITE  := https://www.exiv2.org/
$(PKG)_DESCR    := Exiv2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.27.3
$(PKG)_CHECKSUM := a79f5613812aa21755d578a297874fb59a85101e793edc64ec2c6bd994e3e778
$(PKG)_SUBDIR   := exiv2-$($(PKG)_VERSION)-Source
$(PKG)_FILE     := exiv2-$($(PKG)_VERSION)-Source.tar.gz
$(PKG)_URL      := https://www.exiv2.org/builds/$($(PKG)_FILE)
$(PKG)_DEPS     := cc expat gettext mman-win32 zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.exiv2.org/download.html' | \
    grep 'href="builds/exiv2-' | \
    $(SED) -n 's,.*exiv2-\([0-9][^>]*\)-Source\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(TARGET)-cmake -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DEXIV2_BUILD_SAMPLES=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
