# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qwt
$(PKG)_VERSION  := 6.1.3
$(PKG)_CHECKSUM := 027c32c0473a682c1db5b9cb02ebed5e39a4fbb0afd2306e23b1113c30006042
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).zip
$(PKG)_WEBSITE  := http://qwt.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qtbase qtsvg

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/qwt/files/qwt/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(if $(BUILD_STATIC),\
        echo "QWT_CONFIG -= QwtDll" >> '$(1)/qwtconfig.pri')

    # build
    cd '$(1)/src' && $(PREFIX)/$(TARGET)/qt5/bin/qmake
    $(MAKE) -C '$(1)/src' -f 'Makefile.Release' -j '$(JOBS)' install

    #build sinusplot example to test linkage
    cd '$(1)/examples/sinusplot' && $(PREFIX)/$(TARGET)/qt5/bin/qmake
    $(MAKE) -C '$(1)/examples/sinusplot' -f 'Makefile.Release' -j '$(JOBS)'

    # install
    $(INSTALL) -m755 '$(1)/examples/bin/sinusplot.exe' '$(PREFIX)/$(TARGET)/bin/test-qwt.exe'
endef

