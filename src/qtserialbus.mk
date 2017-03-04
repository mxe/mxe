# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtserialbus
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 58343dd9f2e339d4900a2d4b54ee25ed959cf62bacb012fe61e6b99d7958c10a
$(PKG)_SUBDIR    = $(subst qtbase,qtserialbus,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtserialbus,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtserialbus,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtserialport

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
