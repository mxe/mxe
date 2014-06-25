# This file is part of MXE.
# See index.html for further information.

PKG             := qtimageformats
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := f32c76ebf35e66ee2634638ab8c992e4100e591e
$(PKG)_SUBDIR    = $(subst qtbase,qtimageformats,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtimageformats,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtimageformats,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase libmng tiff

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
