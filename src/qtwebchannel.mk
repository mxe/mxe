# This file is part of MXE.
# See index.html for further information.

PKG             := qtwebchannel
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 6f5c15f50c45df6392ab0e01c47043fd0100a389
$(PKG)_SUBDIR    = $(subst qtbase,qtwebchannel,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtwebchannel,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtwebchannel,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtdeclarative qtwebsockets

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    # invoke qmake with removed debug options as a workaround for
    # https://bugreports.qt-project.org/browse/QTBUG-30898
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' CONFIG-='debug debug_and_release'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
