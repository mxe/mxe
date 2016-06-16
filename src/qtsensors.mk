# This file is part of MXE.
# See index.html for further information.

PKG             := qtsensors
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 283dcc66a24c4367e865fa8301b6ea04d0cb78bd0f166fd09a6bb42e1e3731be
$(PKG)_SUBDIR    = $(subst qtbase,qtsensors,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtsensors,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtsensors,$(qtbase_URL))
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
