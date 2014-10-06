# This file is part of MXE.
# See index.html for further information.

PKG             := qscintilla2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.8.2
$(PKG)_CHECKSUM := cfb24bfec54ea869bc3a326b9a935fc25aea7bec
$(PKG)_SUBDIR   := QScintilla-gpl-$($(PKG)_VERSION)
$(PKG)_FILE     := QScintilla-gpl-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/pyqt/QScintilla2/QScintilla-$($(PKG)_VERSION)/$($(PKG)_FILE) 

$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.riverbankcomputing.com/software/qscintilla/download' | \
        grep QScintilla-gpl | \
        head -n 1 | \
        $(SED) -n 's,.*QScintilla-gpl-\([0-9][^>]*\)\.zip.*,\1,p'
endef

define $(PKG)_BUILD
    cd '$(1)/Qt4Qt5' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' qscintilla.pro
    $(MAKE) -C '$(1)/Qt4Qt5' -j '$(JOBS)'
    $(MAKE) -C '$(1)/Qt4Qt5' -j '$(JOBS)' install

    '$(TARGET)-g++' \
        -W -Wall -Werror -std=c++0x -pedantic \
	`'$(TARGET)-pkg-config' Qt5Widgets --cflags` \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-qscintilla2.exe' -lqscintilla2 \
	`'$(TARGET)-pkg-config' Qt5Widgets --libs`
endef

$(PKG)_BUILD_i686-pc-mingw32 =
