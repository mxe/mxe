# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtquickcontrols2
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 263d3b8751007a45ed083ebc585b572552ab36e2fdc28468994ff29f384c6ad2
$(PKG)_SUBDIR    = $(subst qtbase,qtquickcontrols2,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtquickcontrols2,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtquickcontrols2,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
