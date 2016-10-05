# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtserialbus
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 2c437ace393e9dcf170990b519cec59c5cbcfc3c830e46116abb52549dc15d38
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
