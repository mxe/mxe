# This file is part of MXE.
# See index.html for further information.

PKG             := lua
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.2.3
# Shared version
$(PKG)_SOVERS   := 52
$(PKG)_CHECKSUM := 926b7907bc8d274e063d42804666b40a3f3c124c
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
    $(MAKE) -C '$(1)' -j 1 \
        INSTALL_TOP='$(PREFIX)/$(TARGET)' \
        INSTALL_BIN='$(1)/noinstall' \
        INSTALL_MAN='$(1)/noinstall' \
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
