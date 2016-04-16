# This file is part of MXE.
# See index.html for further information.

PKG             := qtcanvas3d
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 66add59e826a0161f4a4dc3ec0b44c17fad1451390b4f7c67af23ee7429d9ecf
$(PKG)_SUBDIR    = $(subst qtbase,qtcanvas3d,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtcanvas3d,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtcanvas3d,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtdeclarative

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
