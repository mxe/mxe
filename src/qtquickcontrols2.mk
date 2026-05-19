# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtquickcontrols2
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := eb8e76d3b5f811e96cc80328dc173b97d045734d956712c96834f7b73a95687b
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
