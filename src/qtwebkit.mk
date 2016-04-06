# This file is part of MXE.
# See index.html for further information.

PKG             := qtwebkit
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 9ca72373841f3a868a7bcc696956cdb0ad7f5e678c693659f6f0b919fdd16dfe
$(PKG)_SUBDIR    = $(subst qtbase,qtwebkit,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtwebkit,$(qtbase_FILE))
$(PKG)_URL       = $(subst /submodules/,/,$(subst official_releases/qt,community_releases,$(subst qtbase,qtwebkit,$(qtbase_URL))))
$(PKG)_DEPS     := gcc qtbase qtmultimedia sqlite

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD_SHARED
    # looks for build tools with .exe suffix and tries to use win_flex
    $(SED) -i 's,\.exe,,' '$(1)/Tools/qmake/mkspecs/features/functions.prf'
    # invoke qmake with removed debug options as a workaround for
    # https://bugreports.qt-project.org/browse/QTBUG-30898
    cd '$(1)' && mkdir -p .git && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' FLEX=flex CONFIG-='debug debug_and_release'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
