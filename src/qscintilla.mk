# This file is part of MXE.
# See index.html for further information.

PKG             := qscintilla
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.7
$(PKG)_CHECKSUM := 296c03343f5d84f0c06a16eb3fb706e0eb735ea6
$(PKG)_SUBDIR   := QScintilla-gpl-$($(PKG)_VERSION)/Qt4Qt5
$(PKG)_FILE     := QScintilla-gpl-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://sourceforge.net/projects/pyqt/files/QScintilla2/QScintilla-2.7/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package qscintilla.' >&2;
    echo $(qscintilla_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt/bin/qmake' -makefile -spec '$(PREFIX)/$(TARGET)/qt/mkspecs/win32-g++'

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
    $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/qscintilla2.dll' '$(PREFIX)/$(TARGET)/bin/qscintilla2.dll'
endef

$(PKG)_BUILD_i686-pc-mingw32 =
$(PKG)_BUILD_i686-w64-mingw32 =
$(PKG)_BUILD_x86_64-w64-mingw32 =
