# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := opencsg
$(PKG)_WEBSITE  := http://www.opencsg.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.2
$(PKG)_CHECKSUM := d952ec5d3a2e46a30019c210963fcddff66813efc9c29603b72f9553adff4afb
$(PKG)_SUBDIR   := OpenCSG-$($(PKG)_VERSION)
$(PKG)_FILE     := OpenCSG-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.opencsg.org/$($(PKG)_FILE)
$(PKG)_DEPS     := cc freeglut glew qtbase

$(PKG)_QT_DIR   := qt5

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.opencsg.org/#download' | \
    grep 'OpenCSG-' | \
    $(SED) -n 's,.*OpenCSG-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # doesn't support out-of-source build
    cd '$(SOURCE_DIR)/src' && '$(PREFIX)/$(TARGET)/$($(PKG)_QT_DIR)/bin/qmake' src.pro
    $(MAKE) -C '$(SOURCE_DIR)/src' -j '$(JOBS)'
    $(INSTALL) -m644 '$(SOURCE_DIR)/include/opencsg.h' '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(SOURCE_DIR)/lib/libopencsg.a' '$(PREFIX)/$(TARGET)/lib/'

    cd '$(SOURCE_DIR)/example' && '$(PREFIX)/$(TARGET)/$($(PKG)_QT_DIR)/bin/qmake' example.pro
    $(MAKE) -C '$(SOURCE_DIR)/example' -j '$(JOBS)'
    $(INSTALL) -m755 '$(SOURCE_DIR)/example/$(BUILD_TYPE)/opencsgexample.exe' '$(PREFIX)/$(TARGET)/bin/test-opencsg.exe'
endef

$(PKG)_BUILD_SHARED =
