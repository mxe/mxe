# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libcaca
$(PKG)_WEBSITE  := http://caca.zoy.org/wiki/libcaca
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.99.beta19
$(PKG)_CHECKSUM := 128b467c4ed03264c187405172a4e83049342cc8cc2f655f53a2d0ee9d3772f4
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://caca.zoy.org/files/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc dlfcn-win32 freeglut ncurses zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://caca.zoy.org/wiki/libcaca' | \
    $(SED) -n 's,.*/libcaca-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -rV | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && autoreconf -fi
    $(if $(BUILD_STATIC),                                         \
        $(SED) -i 's/__declspec(dllimport)//' '$(1)/caca/caca.h'; \
        $(SED) -i 's/__declspec(dllimport)//' '$(1)/caca/caca0.h')
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --disable-csharp \
        --disable-java \
        --disable-python \
        --disable-ruby \
        --disable-doc \
        $(if $(BUILD_STATIC), LIBS=-luuid)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
    ln -sf '$(PREFIX)/$(TARGET)/bin/caca-config' '$(PREFIX)/bin/$(TARGET)-caca-config'
endef

