# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := dbus
$(PKG)_WEBSITE  := https://dbus.freedesktop.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.15.10
$(PKG)_CHECKSUM := f700f2f1d0473f11e52f3f3e179f577f31b85419f9ae1972af8c3db0bcfde178
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://$(PKG).freedesktop.org/releases/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc expat

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://cgit.freedesktop.org/dbus/dbus/refs/tags' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?h=dbus-\\([0-9][^']*\\)'.*,\\1,p" | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DDBUS_BUILD_TESTS:BOOL=OFF \
        -DDBUS_DISABLE_ASSERT:BOOL=ON \
        -DDBUS_ENABLE_DOXYGEN_DOCS:BOOL=OFF \
        -DDBUS_ENABLE_XML_DOCS:BOOL=OFF \
        -DCMAKE_C_FLAGS='-DPROCESS_QUERY_LIMITED_INFORMATION=0x1000'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
