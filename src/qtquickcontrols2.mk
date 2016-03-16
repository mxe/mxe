# This file is part of MXE.
# See index.html for further information.

PKG             := qtquickcontrols2
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 59ec6ea2282931bc0d0748b3979a52e1a322e7ef8d1e5490b8a34931e8b9fee0
$(PKG)_SUBDIR    = $(subst qtbase,qtquickcontrols2,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtquickcontrols2,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtquickcontrols2,$(qtbase_URL))
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
