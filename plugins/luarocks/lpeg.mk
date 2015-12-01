# This file is part of MXE.
# See index.html for further information.

PKG             := lpeg
$(PKG)_WEBSITE  := http://www.inf.puc-rio.br/~roberto/lpeg/lpeg.html
$(PKG)_OWNER    := https://github.com/starius
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.0
$(PKG)_CHECKSUM := 10190ae758a22a16415429a9eb70344cf29cbda738a6962a9f94a732340abf8e
$(PKG)_SUBDIR   := lpeg-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := http://www.inf.puc-rio.br/~roberto/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc luarocks

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.inf.puc-rio.br/~roberto/lpeg/' | \
    $(SED) -n 's,.*lpeg-\([0-9][^>]*\)\.tar.*,\1,p' | \
    $(SORT) -h | tail -1
endef

# shared-only because luarocks is shared-only

define $(PKG)_BUILD_SHARED
    cd '$(1)' && '$(TARGET)-luarocks' make
endef
