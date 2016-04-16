# This file is part of MXE.
# See index.html for further information.

PKG             := qtxmlpatterns
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := baed1b3bd3f010b8c4a96b4ca7a595b665d43d2e5758b55a364dbc9f2ac819d4
$(PKG)_SUBDIR    = $(subst qtbase,qtxmlpatterns,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtxmlpatterns,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtxmlpatterns,$(qtbase_URL))
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
