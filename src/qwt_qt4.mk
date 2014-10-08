# This file is part of MXE.
# See index.html for further information.

PKG             := qwt_qt4
$(PKG)_VERSION  := 5.2
$(PKG)_CHECKSUM := 01a40259134864bc36a335807c1d2f1157347d36
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_WEBSITE  := http://qwt.sourceforge.net/
$(PKG)_URL      := http://sourceforge.net/projects/mxedeps/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qt

define $(PKG)_UPDATE
    echo 'TODO: Updates for package qwt_qt4 need to be written.' >&2;
endef

define $(PKG)_BUILD
    $(SED) -i '/\INSTALLBASE /s%\INSTALLBASE .*%INSTALLBASE=$(PREFIX)/$(TARGET)/qwt%g' '$(1)/qwtconfig.pri'
    $(if $(BUILD_STATIC),\
        echo "QWT_CONFIG -= QwtDll" >> '$(1)/qwtconfig.pri')
 # build
    cd '$(1)/src' && $(PREFIX)/$(TARGET)/qt/bin/qmake
    $(MAKE) -C '$(1)/src' -f 'Makefile.Release' -j '$(JOBS)' install
endef
