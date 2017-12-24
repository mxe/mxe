# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libspectre
$(PKG)_WEBSITE  := https://libspectre.freedesktop.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.2.8
$(PKG)_CHECKSUM := 65256af389823bbc4ee4d25bfd1cc19023ffc29ae9f9677f2d200fa6e98bc7a8
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
