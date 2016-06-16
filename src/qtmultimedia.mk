# This file is part of MXE.
# See index.html for further information.

PKG             := qtmultimedia
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 05ae705bda224a600b06e390aa7b1448c4a6a52d2d37842d2121fb4a5d84b559
$(PKG)_SUBDIR    = $(subst qtbase,qtmultimedia,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtmultimedia,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtmultimedia,$(qtbase_URL))
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
