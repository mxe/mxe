# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := djvulibre
$(PKG)_WEBSITE  := https://djvu.sourceforge.io/
$(PKG)_DESCR    := DjVuLibre
$(PKG)_VERSION  := 3.5.29
$(PKG)_CHECKSUM := d3b4b03ae2bdca8516a36ef6eb27b777f0528c9eda26745d9962824a3fdfeccf
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/djvu/DjVuLibre/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc pthreads jpeg zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/djvu/files/DjVuLibre/' | \
    $(SED) -n 's,.*/\([0-9][^A-Za-z"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && autoreconf -fi
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)/libdjvu' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)/libdjvu' -j 1 install-strip \
        $(MXE_DISABLE_CRUFT) dist_bin_SCRIPTS=

    '$(TARGET)-g++' \
        -W -Wall -Werror -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' ddjvuapi --cflags --libs`
endef
