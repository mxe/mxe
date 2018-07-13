# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := luasocket
$(PKG)_WEBSITE  := https://www.impa.br/~diego/software/luasocket
$(PKG)_OWNER    := https://github.com/starius
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0-rc1
$(PKG)_CHECKSUM := 8b67d9b5b545e1b694753dab7bd6cdbc24c290f2b21ba1e14c77b32817ea1249
$(PKG)_GH_CONF  := diegonehab/luasocket/tags, v
$(PKG)_DEPS     := cc luarocks

# shared-only because luarocks is shared-only

define $(PKG)_BUILD_SHARED
    cd '$(1)' && '$(TARGET)-luarocks' make
endef
