# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# opencsg
PKG             := opencsg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.1
$(PKG)_CHECKSUM := d94c22d4e824c6b5e69a97a726b514ecaf9e4596
$(PKG)_SUBDIR   := OpenCSG-$($(PKG)_VERSION)
$(PKG)_FILE     := OpenCSG-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.opencsg.org/
$(PKG)_URL      := http://www.opencsg.org/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc freeglut glew qt

define $(PKG)_UPDATE
    wget -q -O- 'http://www.opencsg.org/#download' | \
    grep 'OpenCSG-' | \
    $(SED) -n 's,.*OpenCSG-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)/src' && '$(TARGET)-qmake' src.pro
    $(MAKE) -C '$(1)/src' -j '$(JOBS)'
    cd '$(1)/example' && '$(TARGET)-qmake' example.pro
    $(MAKE) -C '$(1)/example' -j '$(JOBS)'
    $(INSTALL) -m644 '$(1)/lib/libopencsg.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/include/opencsg.h' '$(PREFIX)/$(TARGET)/include/'
endef
