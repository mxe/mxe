# This file is part of MXE.
# See index.html for further information.

PKG             := luabind
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.1
$(PKG)_CHECKSUM := 2e92a18b8156d2e2948951d429cd3482e7347550
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/luabind/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc boost lua

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/luabind/files/luabind/' | \
    $(SED) -n 's,.*<a href="/projects/luabind/files/luabind/\([0-9][^>]*\)/.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        '$(1)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' VERBOSE=1 || $(MAKE) -C '$(1).build' -j 1 VERBOSE=1
    $(MAKE) -C '$(1).build' -j 1 install VERBOSE=1

    # all programs using luabind should define LUA_COMPAT_ALL
    '$(TARGET)-g++' \
        -W -Wall -DLUA_COMPAT_ALL \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-luabind.exe' \
        -llua -lluabind
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =

$(PKG)_BUILD_SHARED =
