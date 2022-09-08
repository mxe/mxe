# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtserialbus
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 3598f923eb9a580c92f8700a336ed6e0794b2b03dca944a40663e9dbfba05659
$(PKG)_SUBDIR    = $(subst qtbase,qtserialbus,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtserialbus,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtserialbus,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase qtserialport

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
