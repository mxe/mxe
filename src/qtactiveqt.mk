# This file is part of MXE.
# See index.html for further information.

PKG             := qtactiveqt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 6adc7be3859d2c0e54ed7edf6caa35e3863dfa3d476ea40cd9acf7c965ca3277
$(PKG)_SUBDIR    = $(subst qtbase,qtactiveqt,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtactiveqt,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtactiveqt,$(qtbase_URL))
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
