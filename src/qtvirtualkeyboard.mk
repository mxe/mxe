# This file is part of MXE.
# See index.html for further information.

PKG             := qtvirtualkeyboard
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := df433de68e23b173b87b422038bc9f3e53349035c11a2b2e495122274664ff2f
$(PKG)_SUBDIR    = $(subst qtbase,qtvirtualkeyboard,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtvirtualkeyboard,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtvirtualkeyboard,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtdeclarative qtmultimedia qtquickcontrols qtsvg

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
