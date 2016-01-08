# This file is part of MXE.
# See index.html for further information.

PKG             := qtdeclarative
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 5fd14eefb83fff36fb17681693a70868f6aaf6138603d799c16466a094b26791
$(PKG)_SUBDIR    = $(subst qtbase,qtdeclarative,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtdeclarative,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtdeclarative,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtsvg qtxmlpatterns

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
