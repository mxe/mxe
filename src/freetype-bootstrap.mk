# This file is part of MXE.
# See index.html for further information.

PKG            := freetype-bootstrap
$(PKG)_IGNORE   = $(freetype_IGNORE)
$(PKG)_VERSION  = $(freetype_VERSION)
$(PKG)_CHECKSUM = $(freetype_CHECKSUM)
$(PKG)_SUBDIR   = $(freetype_SUBDIR)
$(PKG)_FILE     = $(freetype_FILE)
$(PKG)_URL      = $(freetype_URL)
$(PKG)_DEPS    := gcc bzip2 libpng zlib

define $(PKG)_UPDATE
    echo $(freetype_VERSION)
endef

define $(PKG)_BUILD
    $(freetype_BUILD)
endef
