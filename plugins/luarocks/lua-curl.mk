# This file is part of MXE.
# See index.html for further information.

PKG             := lua-curl
$(PKG)_WEBSITE  := https://github.com/Lua-cURL/Lua-cURLv3
$(PKG)_OWNER    := https://github.com/Lua-cURL
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3735522
$(PKG)_CHECKSUM := efb1a42f7a6660a64571e98a8e523daabb3aefbae84a73f50fa86a94bf505dab
$(PKG)_SUBDIR   := Lua-cURL-Lua-cURLv3-$($(PKG)_VERSION)
$(PKG)_FILE     := Lua-cURLv3-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/Lua-cURL/Lua-cURLv3/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc curl luarocks

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_SHA, Lua-cURL/Lua-cURLv3, master) | $(SED) 's/^\(.......\).*/\1/;'
endef

define $(PKG)_BUILD_SHARED
    cd '$(1)' && '$(TARGET)-luarocks' make rockspecs/lua-curl-scm-0.rockspec
endef

