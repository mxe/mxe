# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtserialport
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 1faf7df4a1f9028bef1ce79330badb4e5cbbba9f717c53cafc5aea41eed1de51
$(PKG)_SUBDIR    = $(subst qtbase,qtserialport,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtserialport,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtserialport,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
