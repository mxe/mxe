# This file is part of MXE.
# See index.html for further information.

PKG             := qtwebkit
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 8489ffa9253ab429b75f65117e435624dd78f769
$(PKG)_SUBDIR    = $(subst qtbase,qtwebkit,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtwebkit,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtwebkit,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtmultimedia qtquick1 sqlite

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD_SHARED
    echo qtwebkit is deprecated in Qt 5.5
endef

define $(PKG)_BUILD_SHARED_DISABLED
    # looks for build tools with .exe suffix and tries to use win_flex
    $(SED) -i 's,\.exe,,' '$(1)/Tools/qmake/mkspecs/features/functions.prf'
    # invoke qmake with removed debug options as a workaround for
    # https://bugreports.qt-project.org/browse/QTBUG-30898
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' FLEX=flex CONFIG-='debug debug_and_release'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
