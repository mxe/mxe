# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qwt5_qt4
$(PKG)_WEBSITE  := https://qwt.sourceforge.io/
$(PKG)_DESCR    := Qwt
$(PKG)_VERSION  := 5.2.3
$(PKG)_CHECKSUM := a23e583ae66a70f21bf2acb87624eb142a5c310088687f7fa51fa3fb8222b5e5
$(PKG)_SUBDIR   := qwt-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).zip
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/qwt/qwt/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qt

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/qwt/files/qwt/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(if $(BUILD_STATIC),\
	sed -i -e 's/+= QwtDll/-= QwtDll/' '$(1)/qwtconfig.pri')

    sed -i -e 's/target.path.*$$/target.path = $$$$PREFIX\/lib\/qwt5/' '$(1)/qwtconfig.pri'
    sed -i -e 's/headers.path.*$$/headers.path = $$$$PREFIX\/include\/qwt5/' '$(1)/qwtconfig.pri'

    # build
    cd '$(1)/src' && $(PREFIX)/$(TARGET)/qt/bin/qmake PREFIX=$(PREFIX)\/$(TARGET)/qt
    $(MAKE) -C '$(1)/src' -f 'Makefile.Release' -j '$(JOBS)' install

endef

