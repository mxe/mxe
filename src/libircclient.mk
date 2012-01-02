# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# libircclient
# Note that IPv6 support is partly broken and therefore disabled.
PKG             := libircclient
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3
$(PKG)_CHECKSUM := 19b01d0227e717b58630037131798ee34fb0b414
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://sourceforge.net/projects/$(PKG)/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/libircclient/files/libircclient/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --disable-debug \
        --enable-threads \
        --disable-ipv6
    $(MAKE) -C '$(1)'/src -j '$(JOBS)'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/src/libircclient.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/libircclient'
    $(INSTALL) -m644 '$(1)/include/libircclient.h' '$(PREFIX)/$(TARGET)/include/libircclient' 
    $(INSTALL) -m644 '$(1)/include/libirc_errors.h' '$(PREFIX)/$(TARGET)/include/libircclient'
    $(INSTALL) -m644 '$(1)/include/libirc_events.h' '$(PREFIX)/$(TARGET)/include/libircclient'
    $(INSTALL) -m644 '$(1)/include/libirc_rfcnumeric.h' '$(PREFIX)/$(TARGET)/include/libircclient'
    $(INSTALL) -m644 '$(1)/include/libirc_options.h' '$(PREFIX)/$(TARGET)/include/libircclient'

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-libircclient.exe' \
        -lircclient -lws2_32
endef
