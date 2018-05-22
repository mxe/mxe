# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := llthreads2
$(PKG)_WEBSITE  := https://github.com/moteus/lua-llthreads2
$(PKG)_OWNER    := https://github.com/starius
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.3
$(PKG)_CHECKSUM := 8c6fc7966cdcc15ae2f89f66ae72f6727a985e7d254f139ecf75a50956a3e8e4
$(PKG)_GH_CONF  := moteus/lua-llthreads2/tags, v
$(PKG)_DEPS     := cc luarocks

# shared-only because luarocks is shared-only

define $(PKG)_BUILD_SHARED
    cd '$(1)' && '$(TARGET)-luarocks' make \
        rockspecs/lua-llthreads2-scm-0.rockspec
endef
