# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qscintilla2
$(PKG)_WEBSITE  := https://www.riverbankcomputing.com/software/qscintilla/intro
$(PKG)_DESCR    := QScintilla2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.10.8
$(PKG)_CHECKSUM := 46cd5b4e609ca5e13130ba8cc7028d44fd1dc5b037f97c492899006ed0c992eb
$(PKG)_SUBDIR   := QScintilla_gpl-$($(PKG)_VERSION)
$(PKG)_FILE     := QScintilla_gpl-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/pyqt/QScintilla2/QScintilla-$($(PKG)_VERSION)/$($(PKG)_FILE)

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
        -W -Wall -Werror -std=c++0x -pedantic \
        `'$(TARGET)-pkg-config' Qt5Widgets --cflags` \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-qscintilla2.exe' -lqscintilla2_qt5 \
        `'$(TARGET)-pkg-config' Qt5Widgets --libs`
endef
