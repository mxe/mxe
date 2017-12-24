# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := luv
$(PKG)_WEBSITE  := https://github.com/luvit/luv
$(PKG)_OWNER    := https://github.com/starius
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.9.0-1
$(PKG)_CHECKSUM := fab5ba54f141711afc432216d03f3664710798204c78a2a7414479f10b2b2d83
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://github.com/luvit/luv/releases/download/1.9.0-1/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libuv luarocks

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, luvit/luv)
endef

# shared-only because luarocks is shared-only

define $(PKG)_BUILD_SHARED
    cd '$(1)' && '$(TARGET)-luarocks' make
endef
