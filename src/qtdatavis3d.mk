# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtdatavis3d
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 530ce50f95f27599055fbcbdc601d0d32b14dd36eba8a93a1a5b2a7adaca01f8
$(PKG)_SUBDIR    = $(subst qtbase,qtdatavis3d,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtdatavis3d,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtdatavis3d,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase qtdeclarative qtmultimedia

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
