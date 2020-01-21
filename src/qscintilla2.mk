# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qscintilla2
$(PKG)_WEBSITE  := https://www.riverbankcomputing.com/software/qscintilla/intro
$(PKG)_DESCR    := QScintilla2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.11.2
$(PKG)_CHECKSUM := 029bdc476a069fda2cea3cd937ba19cc7fa614fb90578caef98ed703b658f4a1
$(PKG)_SUBDIR   := QScintilla_gpl-$($(PKG)_VERSION)
$(PKG)_FILE     := QScintilla_gpl-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.riverbankcomputing.com/static/Downloads/QScintilla/$($(PKG)_VERSION)/$($(PKG)_FILE)

$(PKG)_DEPS     := cc qtbase

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.riverbankcomputing.com/software/qscintilla/download' | \
    grep QScintilla_gpl | \
    head -n 1 | \
    $(SED) -n 's,.*QScintilla_gpl-\([0-9][^>]*\)\.tar.*,\1,p'
endef

define $(PKG)_BUILD
    cd '$(1)/Qt4Qt5' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' qscintilla.pro \
        $(if $(BUILD_STATIC),CONFIG+=staticlib)
    $(MAKE) -C '$(1)/Qt4Qt5' -j '$(JOBS)'
    $(MAKE) -C '$(1)/Qt4Qt5' -j '$(JOBS)' install

    '$(TARGET)-g++' \
        -W -Wall -Werror -std=c++0x -pedantic -Wno-deprecated-copy \
        `'$(TARGET)-pkg-config' Qt5Widgets --cflags` \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-qscintilla2.exe' -lqscintilla2_qt5 \
        `'$(TARGET)-pkg-config' Qt5Widgets --libs`
endef
