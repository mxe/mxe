# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libexif
$(PKG)_WEBSITE  := https://github.com/libexif/libexif
$(PKG)_DESCR    := libexif
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.6.22
$(PKG)_CHECKSUM := 46498934b7b931526fdee8fd8eb77a1dddedd529d5a6dbce88daf4384baecc54
$(PKG)_GH_CONF  := libexif/libexif/releases, libexif-,-release,,_
$(PKG)_DEPS     := cc gettext

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && autoreconf -fi
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        $(PKG_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' install

    '$(TARGET)-gcc' \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' libexif --cflags --libs`
endef
