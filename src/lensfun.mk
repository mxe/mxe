# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := lensfun
$(PKG)_WEBSITE  := https://lensfun.sourceforge.io/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.3.2
$(PKG)_CHECKSUM := ae8bcad46614ca47f5bda65b00af4a257a9564a61725df9c74cb260da544d331
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/lensfun/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc glib libgnurx libpng

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/lensfun/files/' | \
    $(SED) -n 's,.*/projects/.*/\([0-9][^"]*\)/".*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/building'
    cd '$(1)/building' && '$(TARGET)-cmake' .. \
        -DCMAKE_INSTALL_PREFIX='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)/building' -j '$(JOBS)' install VERBOSE=1

    # Don't use `-ansi`, as lensfun uses C++-style `//` comments.
    '$(TARGET)-gcc' \
        -W -Wall -Werror \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-lensfun.exe' \
        `'$(TARGET)-pkg-config' lensfun glib-2.0 --cflags --libs`
endef
