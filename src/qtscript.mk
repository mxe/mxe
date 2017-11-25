# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtscript
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 6cf2f2f09ccafa9c9cd5d16641ae2b75b7f98947de6ec0ec1717489f3a09cafc
$(PKG)_SUBDIR    = $(subst qtbase,qtscript,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtscript,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtscript,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
