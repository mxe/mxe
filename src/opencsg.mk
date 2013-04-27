# This file is part of MXE.
# See index.html for further information.

PKG             := opencsg
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := e2b4abf169ae3e319eb5f6d9ae6136fa96710a05
$(PKG)_SUBDIR   := OpenCSG-$($(PKG)_VERSION)
$(PKG)_FILE     := OpenCSG-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.opencsg.org/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc freeglut glew qt

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.opencsg.org/#download' | \
    grep 'OpenCSG-' | \
    $(SED) -n 's,.*OpenCSG-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)/src' && '$(PREFIX)/$(TARGET)/qt/bin/qmake' src.pro
    $(MAKE) -C '$(1)/src' -j '$(JOBS)'
    $(INSTALL) -m644 '$(1)/include/opencsg.h' '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/lib/libopencsg.a' '$(PREFIX)/$(TARGET)/lib/'

    cd '$(1)/example' && '$(PREFIX)/$(TARGET)/qt/bin/qmake' example.pro
    $(MAKE) -C '$(1)/example' -j '$(JOBS)'
    $(INSTALL) -m755 '$(1)/example/release/opencsgexample.exe' '$(PREFIX)/$(TARGET)/bin/test-opencsg.exe'
endef
