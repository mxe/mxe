# This file is part of MXE.
# See index.html for further information.

PKG             := qwt5_qt4
$(PKG)_VERSION  := 5.2.3
$(PKG)_CHECKSUM := ff81595a1641a8b431f98d6091bb134bc94e0003
$(PKG)_SUBDIR   := qwt-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.bz2
$(PKG)_WEBSITE  := http://qwt.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/qwt/qwt/$($(PKG)_VERSION)/$($(PKG)_FILE)

$(PKG)_DEPS     := gcc qt

define $(PKG)_UPDATE
    echo 'TODO: Updates for package qwt5 need to be written.' >&2;
    echo '$(qwt5_VERSION)'
endef

define $(PKG)_BUILD
    $(SED) -i '/\INSTALLBASE /s%\INSTALLBASE .*%INSTALLBASE=$(PREFIX)/$(TARGET)/qt%g' '$(1)/qwtconfig.pri'
    $(if $(BUILD_STATIC),\
        echo "QWT_CONFIG -= QwtDll" >> '$(1)/qwtconfig.pri')
 # build
    cd '$(1)/src' && $(PREFIX)/$(TARGET)/qt/bin/qmake
    $(MAKE) -C '$(1)/src' -f 'Makefile.Release' -j '$(JOBS)' install

    #build sinusplot example to test linkage
    cd '$(1)/examples/simple_plot' && $(PREFIX)/$(TARGET)/qt/bin/qmake
    $(MAKE) -C '$(1)/examples/simple_plot' -f 'Makefile.Release' -j '$(JOBS)'

    # install
    $(INSTALL) -m755 '$(1)/examples/bin/simple.exe' '$(PREFIX)/$(TARGET)/bin/test-qwt5.exe'

endef
