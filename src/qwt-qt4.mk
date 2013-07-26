# This file is part of MXE.
# See index.html for further information.

PKG             := qwt-qt4
$(PKG)_VERSION  := 6.1.0
$(PKG)_CHECKSUM := 2d95abf1fc4578684e141e0c76df266f9dae080a
$(PKG)_SUBDIR   := qwt-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).zip
$(PKG)_WEBSITE  := http://qwt.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/qwt/qwt/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qt

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/qwt/files/qwt/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # build
    cd '$(1)/src' && $(PREFIX)/$(TARGET)/qt/bin/qmake
    $(MAKE) -C '$(1)/src' -f 'Makefile.Release' -j '$(JOBS)' install

    #build sinusplot example to test linkage
    cd '$(1)/examples/sinusplot' && $(PREFIX)/$(TARGET)/qt/bin/qmake
    $(MAKE) -C '$(1)/examples/sinusplot' -f 'Makefile.Release' -j '$(JOBS)'

    # install
    $(INSTALL) -m755 '$(1)/examples/bin/sinusplot.exe' '$(PREFIX)/$(TARGET)/bin/test-qwt-qt4.exe'
endef
