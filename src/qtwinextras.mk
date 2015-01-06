# This file is part of MXE.
# See index.html for further information.

PKG             := qtwinextras
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 99330ce86e0a706f0b9328e44f4101acddbaa81a
$(PKG)_SUBDIR    = $(subst qtbase,qtwinextras,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtwinextras,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtwinextras,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtdeclarative qtmultimedia

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

$(PKG)_BUILD_i686-pc-mingw32 =
