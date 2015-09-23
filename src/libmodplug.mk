# This file is part of MXE.
# See index.html for further information.

PKG             := libmodplug
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.8.8.4
$(PKG)_CHECKSUM := 5c5ee13dddbed144be26276e5f102da17ff5b1c992f3100389983082da2264f7
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/modplug-xmms/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/modplug-xmms/files/libmodplug/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libmodplug.exe' \
        `'$(TARGET)-pkg-config' libmodplug --cflags --libs`
endef
