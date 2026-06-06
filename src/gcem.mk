# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gcem
$(PKG)_WEBSITE  := https://github.com/kthohr/gcem
$(PKG)_DESCR    := gcem
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.18.0
$(PKG)_CHECKSUM := 8e71a9f5b62956da6c409dda44b483f98c4a98ae72184f3aa4659ae5b3462e61
$(PKG)_GH_CONF  := kthohr/gcem/tags,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    cp -Rp '$(SOURCE_DIR)/include/'* '$(PREFIX)/$(TARGET)/include/'
endef
