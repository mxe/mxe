# This file is part of MXE.
# See index.html for further information.

PKG             := qtsvg
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 798799319138bb40b6187f4ecc1099956a0d62148f78512e9cb085d1fa5f641f
$(PKG)_SUBDIR    = $(subst qtbase,qtsvg,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtsvg,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtsvg,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase

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
