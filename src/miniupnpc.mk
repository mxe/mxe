# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := miniupnpc
$(PKG)_WEBSITE  := http://miniupnp.free.fr/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.9
$(PKG)_CHECKSUM := 2923e453e880bb949e3d4da9f83dd3cb6f08946d35de0b864d0339cf70934464
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://miniupnp.free.fr/files/$($(PKG)_FILE)
$(PKG)_URL_2    := https://miniupnp.tuxfamily.org/files/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://api.github.com/repos/miniupnp/miniupnp/git/refs/tags/' | \
    $(SED) -n 's#.*"ref": "refs/tags/miniupnpc_\([^"]*\).*#\1#p' | \
    $(SED) 's,_,.,g' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(TARGET)-cmake' '$(1)' \
        -DUPNPC_BUILD_STATIC=$(CMAKE_STATIC_BOOL) \
        -DUPNPC_BUILD_SHARED=$(CMAKE_SHARED_BOOL) \
        -DUPNPC_BUILD_TESTS=OFF
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
