# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qwt
$(PKG)_WEBSITE  := https://qwt.sourceforge.io/
$(PKG)_DESCR    := Qwt
$(PKG)_VERSION  := 6.1.4
$(PKG)_CHECKSUM := 77a5d17972865a45ca2f77b16aecd4fc7d7f913f9c705530eb586de51079abaa
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).zip
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_QT_DIR   := qt5
$(PKG)_DEPS     := cc qtbase qtsvg

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/qwt/files/qwt/' | \
    $(SED) -n 's,.*/projects/.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(if $(BUILD_STATIC),\
        echo "QWT_CONFIG -= QwtDll" >> '$(SOURCE_DIR)/qwtconfig.pri')

    # doesn't support out-of-source build
    cd '$(SOURCE_DIR)' && $(PREFIX)/$(TARGET)/$($(PKG)_QT_DIR)/bin/qmake \
        -after \
        'SUBDIRS -= doc designer' \
        'CONFIG -= debug_and_release'
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(SOURCE_DIR)' -j 1 install

    #build sinusplot example to test linkage
    cd '$(SOURCE_DIR)/examples/sinusplot' && $(PREFIX)/$(TARGET)/$($(PKG)_QT_DIR)/bin/qmake
    $(MAKE) -C '$(SOURCE_DIR)/examples/sinusplot' -f 'Makefile.Release' -j '$(JOBS)'

    # install
    $(INSTALL) -m755 '$(SOURCE_DIR)/examples/bin/sinusplot.exe' '$(PREFIX)/$(TARGET)/bin/test-qwt.exe'
endef
