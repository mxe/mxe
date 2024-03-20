# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libspectre
$(PKG)_WEBSITE  := https://libspectre.freedesktop.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.2.12
$(PKG)_CHECKSUM := 55a7517cd3572bd2565df0cf450944a04d5273b279ebb369a895391957f0f960
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://libspectre.freedesktop.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := cc cairo ghostscript

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://libspectre.freedesktop.org/releases/' | \
    $(SED) -n 's:.*>LATEST-libspectre-::p' | \
    $(SED) -n 's:<.*::p'
endef

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && autoreconf -f -i
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-silent-rules \
        --enable-test
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' install
    echo "Requires: cairo ghostscript" >> '$(PREFIX)/$(TARGET)/lib/pkgconfig/libspectre.pc'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
