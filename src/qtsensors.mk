# This file is part of MXE.
# See index.html for further information.

PKG             := qtsensors
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 518f392fec5e01aaa7f95e9141678cc99b02ed067ebbd24c38c1420067c59c2e
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
