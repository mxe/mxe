# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtimageformats
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 4f97a2a2b269f8a45576256ad9f452320c9c9de6d9c7cc1751fdeac36b0f77f4
$(PKG)_SUBDIR    = $(subst qtbase,qtimageformats,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtimageformats,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtimageformats,$(qtbase_URL))
$(PKG)_DEPS     := gcc jasper libmng libwebp qtbase tiff

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
