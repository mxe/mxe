# This file is part of MXE.
# See index.html for further information.

PKG             := qwt5
$(PKG)_VERSION  := 5.2.3
$(PKG)_CHECKSUM := c24dc6572dfe56ea4c834890e815210d33244d3a
$(PKG)_SUBDIR   := qwt-$($(PKG)_VERSION)
$(PKG)_FILE     := qwt-$($(PKG)_VERSION).zip
$(PKG)_WEBSITE  := http://qwt.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/qwt/qwt/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qtbase qtsvg

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/qwt/files/qwt/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(if $(BUILD_STATIC),\
	sed -ie '/CONFIG           += QwtDll/d' $(1)/qwtconfig.pri)

	sed -ie "s@INSTALLBASE.*=.*@INSTALLBASE=$(PREFIX)/$(TARGET)/qt@" $(1)/qwtconfig.pri

    # build
    cd '$(1)/src' && $(PREFIX)/bin/$(TARGET)-qmake-qt4 
    $(MAKE) -C '$(1)/src' -f 'Makefile.Release' -j '$(JOBS)' install

    #build simple_plot example to test linkage
#    cd '$(1)/examples/simple_plot' && $(PREFIX)/bin/$(TARGET)-qmake-qt4
#    $(MAKE) -C '$(1)/examples/simple_plot' -f 'Makefile.Release' -j '$(JOBS)'
#
#    # install
#    $(INSTALL) -m755 '$(1)/examples/bin/simple_plot.exe' '$(PREFIX)/$(TARGET)/bin/test-qwt.exe'
endef

