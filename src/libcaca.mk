# This file is part of MXE.
# See index.html for further information.

PKG             := libcaca
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.99.beta19
$(PKG)_CHECKSUM := 128b467c4ed03264c187405172a4e83049342cc8cc2f655f53a2d0ee9d3772f4
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://caca.zoy.org/raw-attachment/wiki/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc freeglut ncurses zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://caca.zoy.org/wiki/libcaca' | \
    $(SED) -n 's,.*/libcaca-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -rV | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi
    $(if $(BUILD_STATIC),                                         \
        $(SED) -i 's/__declspec(dllimport)//' '$(1)/caca/caca.h'; \
        $(SED) -i 's/__declspec(dllimport)//' '$(1)/caca/caca0.h')
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-csharp \
        --disable-java \
        --disable-python \
        --disable-ruby \
        --disable-doc
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
    ln -sf '$(PREFIX)/$(TARGET)/bin/caca-config' '$(PREFIX)/bin/$(TARGET)-caca-config'
endef

