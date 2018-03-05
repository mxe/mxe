# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := luasocket
$(PKG)_WEBSITE  := http://www.impa.br/~diego/software/luasocket
$(PKG)_OWNER    := https://github.com/starius
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0-rc1
$(PKG)_CHECKSUM := 8b67d9b5b545e1b694753dab7bd6cdbc24c290f2b21ba1e14c77b32817ea1249
$(PKG)_SUBDIR   := luasocket-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://github.com/diegonehab/luasocket/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc luarocks

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, diegonehab/luasocket, v)
endef

# shared-only because luarocks is shared-only

define $(PKG)_BUILD_SHARED
    cd '$(1)' && '$(TARGET)-luarocks' make
endef
