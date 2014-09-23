# This file is part of MXE.
# See index.html for further information.

PKG             := qtwebkit
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 5ac040cd1fbf953ff9abc0502489bff8f4aa5ac2
$(PKG)_SUBDIR    = $(subst qtbase,qtwebkit,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtwebkit,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtwebkit,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtmultimedia qtquick1

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD_SHARED
    # looks for build tools with .exe suffix and tries to use win_flex
    $(SED) -i 's,\.exe,,' '$(1)/Tools/qmake/mkspecs/features/functions.prf'
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' FLEX=flex
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

$(PKG)_BUILD_i686-pc-mingw32 =
