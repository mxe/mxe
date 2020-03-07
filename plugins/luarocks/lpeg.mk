# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := lpeg
$(PKG)_WEBSITE  := http://www.inf.puc-rio.br/~roberto/lpeg/
$(PKG)_OWNER    := https://github.com/starius
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.1
$(PKG)_CHECKSUM := 62d9f7a9ea3c1f215c77e0cadd8534c6ad9af0fb711c3f89188a8891c72f026b
$(PKG)_SUBDIR   := lpeg-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := http://www.inf.puc-rio.br/~roberto/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc luarocks

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.inf.puc-rio.br/~roberto/lpeg/' | \
    $(SED) -n 's,.*lpeg-\([0-9][^>]*\)\.tar.*,\1,p' | \
    $(SORT) -h | tail -1
endef

# shared-only because luarocks is shared-only

define $(PKG)_BUILD_SHARED
    cd '$(1)' && '$(TARGET)-luarocks' make
endef
