# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtnetworkauth
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 854127960477daddde3051211756d52708f9827ea751a80312c3ff3fb9bc553b
$(PKG)_SUBDIR    = $(subst qtbase,qtnetworkauth,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtnetworkauth,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtnetworkauth,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
