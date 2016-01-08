# This file is part of MXE.
# See index.html for further information.

PKG             := lua-rapidjson
$(PKG)_WEBSITE  := https://github.com/xpol/lua-rapidjson
$(PKG)_OWNER    := https://github.com/starius
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.2.2-1
$(PKG)_CHECKSUM := 10783d8633df3f50b1ad33c7de89d2a94a7d9cf45e2ce5217d0d2d5e77396fd2
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://github.com/xpol/lua-rapidjson/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc luarocks

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, xpol/lua-rapidjson, v)
endef

# shared-only because luarocks is shared-only

define $(PKG)_BUILD_SHARED
    cd '$(1)' && '$(TARGET)-luarocks' make
endef
