# This file is part of MXE. See LICENSE.md for licensing information.

PKG            := freetype-bootstrap
$(PKG)_WEBSITE := https://www.freetype.org/
$(PKG)_DESCR   := freetype (without harfbuzz)
$(PKG)_IGNORE   = $(freetype_IGNORE)
$(PKG)_VERSION  = $(freetype_VERSION)
$(PKG)_CHECKSUM = $(freetype_CHECKSUM)
$(PKG)_SUBDIR   = $(freetype_SUBDIR)
$(PKG)_FILE     = $(freetype_FILE)
$(PKG)_URL      = $(freetype_URL)
$(PKG)_DEPS    := cc bzip2 libpng zlib

define $(PKG)_UPDATE
    echo $(freetype_VERSION)
endef

define $(PKG)_BUILD
    $(subst harfbuzz=yes,harfbuzz=no,$(freetype_BUILD_COMMON))
endef
