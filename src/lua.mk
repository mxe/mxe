# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

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
        a
    $(MAKE) -C '$(1)' -j 1 \
        INSTALL_TOP='$(PREFIX)/$(TARGET)' \
        INSTALL_BIN='$(1)/noinstall' \
        INSTALL_MAN='$(1)/noinstall' \
        TO_BIN='lua.h' \
        RANLIB='$(TARGET)-ranlib' \
        INSTALL='$(INSTALL)' \
        install ranlib
endef
