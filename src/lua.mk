# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# Lua
PKG             := lua
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.1.4
$(PKG)_CHECKSUM := 2b11c8e60306efb7f0734b747588f57995493db7
$(PKG)_SUBDIR   := lua-$($(PKG)_VERSION)
$(PKG)_FILE     := lua-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.lua.org/
$(PKG)_URL      := http://www.lua.org/ftp/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.lua.org/download.html' | \
    $(SED) -n 's,.*lua-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(1)/src' -j '$(JOBS)' \
        INSTALL_TOP='$(PREFIX)/$(TARGET)' \
        CC='$(TARGET)-gcc' \
        AR='$(TARGET)-ar rcu' \
        RANLIB='$(TARGET)-ranlib' \
        a
    $(MAKE) -C '$(1)' -j 1 \
        INSTALL_TOP='$(PREFIX)/$(TARGET)' \
        INSTALL_BIN='$(1)/noinstall' \
        INSTALL_MAN='$(1)/noinstall' \
        TO_BIN='lua.h' \
        INSTALL='$(INSTALL)' \
        install
    $(SED) -i 's,^prefix=.*,prefix=$(PREFIX)/$(TARGET),' '$(1)/etc/lua.pc'
    $(INSTALL) -m644 '$(1)/etc/lua.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig/lua.pc'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-lua.exe' \
        `'$(TARGET)-pkg-config' lua --cflags --libs`
endef
