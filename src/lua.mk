# This file is part of MXE.
# See index.html for further information.

PKG             := lua
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.3.1
# Shared version
$(PKG)_SOVERS   := 53
$(PKG)_CHECKSUM := 072767aad6cc2e62044a66e8562f51770d941e972dc1e4068ba719cd8bffac17
$(PKG)_SUBDIR   := lua-$($(PKG)_VERSION)
$(PKG)_FILE     := lua-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.lua.org/ftp/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.lua.org/download.html' | \
    $(SED) -n 's,.*lua-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD_COMMON
    #pkg-config file
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $(PKG)'; \
     echo 'Libs: -l$(PKG)';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-lua.exe' \
        `$(TARGET)-pkg-config --libs lua`
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(1)/src' -j '$(JOBS)' \
        INSTALL_TOP='$(PREFIX)/$(TARGET)' \
        CC='$(TARGET)-gcc' \
        AR='$(TARGET)-ar rcu' \
        RANLIB='$(TARGET)-ranlib' \
        a

    # lua.h is installed to noinstall/ to avoid error when executing an empty
    # 'install' command.
    $(MAKE) -C '$(1)' -j 1 \
        INSTALL_TOP='$(PREFIX)/$(TARGET)' \
        INSTALL_BIN='$(1)/noinstall' \
        INSTALL_MAN='$(1)/noinstall' \
        TO_BIN='lua.h' \
        INSTALL='$(INSTALL)' \
        install
    $($(PKG)_BUILD_COMMON)
endef

define $(PKG)_BUILD_SHARED
    $(MAKE) -C '$(1)/src' -j '$(JOBS)' \
        INSTALL_TOP='$(PREFIX)/$(TARGET)' \
        CC='$(TARGET)-gcc' \
        AR='$(TARGET)-gcc -Wl,--out-implib,liblua.dll.a -shared -o' \
        RANLIB='echo skipped ranlib' \
        SYSCFLAGS='-DLUA_BUILD_AS_DLL' \
        LUA_A=lua$($(PKG)_SOVERS).dll \
        a
    $(MAKE) -C '$(1)' -j 1 \
        INSTALL_TOP='$(PREFIX)/$(TARGET)' \
        INSTALL_MAN='$(1)/noinstall' \
        TO_BIN='lua$($(PKG)_SOVERS).dll' \
        INSTALL='$(INSTALL)' \
        TO_LIB='liblua.dll.a' \
        install
    $($(PKG)_BUILD_COMMON)
endef

# disable native build temporarily
define $(PKG)_BUILD_DISABLED
    $(MAKE) -C '$(1)/src' -j '$(JOBS)' \
        INSTALL_TOP='$(PREFIX)/$(TARGET)' \
        INSTALL='$(INSTALL)' \
        PLAT=$(shell ([ `uname -s` == Darwin ] && echo "macosx") || echo `uname -s` | tr '[:upper:]' '[:lower:]')
    $(MAKE) -C '$(1)' -j 1 \
        INSTALL_TOP='$(PREFIX)/$(TARGET)' \
        INSTALL='$(INSTALL)' \
        install
endef
