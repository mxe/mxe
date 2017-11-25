# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := lua
$(PKG)_WEBSITE  := https://www.lua.org/
$(PKG)_DESCR    := Lua
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.3.3
# Shared version and luarocks subdir
$(PKG)_SHORTVER := $(call SHORT_PKG_VERSION,$(PKG))
$(PKG)_DLLVER   := $(subst .,,$($(PKG)_SHORTVER))
$(PKG)_CHECKSUM := 5113c06884f7de453ce57702abaac1d618307f33f6789fa870e87a59d772aca2
$(PKG)_SUBDIR   := lua-$($(PKG)_VERSION)
$(PKG)_FILE     := lua-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.lua.org/ftp/$($(PKG)_FILE)
$(PKG)_DEPS     := cc
$(PKG)_DEPS_$(BUILD) :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.lua.org/download.html' | \
    $(SED) -n 's,.*lua-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD_COMMON
    touch '$(PREFIX)/$(TARGET)/lib/lua/$($(PKG)_SHORTVER)/.gitkeep'
    touch '$(PREFIX)/$(TARGET)/share/lua/$($(PKG)_SHORTVER)/.gitkeep'

    #pkg-config file
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $(PKG)'; \
     echo 'Libs: -l$(PKG)';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    cp '$(1)/src/lua' '$(PREFIX)/$(TARGET)/bin/lua.exe'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-lua.exe' \
        `$(TARGET)-pkg-config --libs lua`
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(1)/src' -j '$(JOBS)' \
        INSTALL_TOP='$(PREFIX)/$(TARGET)' \
        CC='$(TARGET)-gcc' \
        AR='$(TARGET)-ar rcu' \
        RANLIB='$(TARGET)-ranlib' \
        a lua

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
        LUA_A=lua$($(PKG)_DLLVER).dll \
        a lua
    $(MAKE) -C '$(1)' -j 1 \
        INSTALL_TOP='$(PREFIX)/$(TARGET)' \
        INSTALL_MAN='$(1)/noinstall' \
        TO_BIN='lua$($(PKG)_DLLVER).dll' \
        INSTALL='$(INSTALL)' \
        TO_LIB='liblua.dll.a' \
        install

    $($(PKG)_BUILD_COMMON)
endef

define $(PKG)_BUILD_$(BUILD)
    $(MAKE) -C '$(1)/src' -j '$(JOBS)' \
        CC='$(BUILD_CC)' \
        PLAT=$(shell ([ `uname -s` == Darwin ] && echo "macosx") || echo `uname -s` | tr '[:upper:]' '[:lower:]')
    $(INSTALL) '$(1)/src/lua' '$(PREFIX)/bin/$(BUILD)-lua'
    ln -sf '$(PREFIX)/bin/$(BUILD)-lua' '$(PREFIX)/$(BUILD)/bin/lua'
    $(INSTALL) '$(1)/src/luac' '$(PREFIX)/bin/$(BUILD)-luac'
    ln -sf '$(PREFIX)/bin/$(BUILD)-luac' '$(PREFIX)/$(BUILD)/bin/luac'
endef
