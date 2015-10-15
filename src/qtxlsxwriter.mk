# This file is part of MXE.
# See index.html for further information.
PKG             := qtxlsxwriter
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := ad90b6a2c21b300138ceb9fe9030a5917230f92d
$(PKG)_CHECKSUM := bebf32dab284d4774bedc6dc897ede5c74531495f28f2be66191fbdc3e1ce01f
$(PKG)_SUBDIR   := QtXlsxWriter-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/dbzhang800/QtXlsxWriter/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc qtbase

$(PKG)_UPDATE    = $(call MXE_GET_GITHUB_SHA, dbzhang800/QtXlsxWriter, master)

define $(PKG)_BUILD
    # invoke qmake with removed debug options as a workaround for
    # https://bugreports.qt-project.org/browse/QTBUG-30898
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' CONFIG-='debug debug_and_release'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
