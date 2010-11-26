# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# minixml
PKG             := mxml
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.6
$(PKG)_CHECKSUM := df180bd2e3890c97fa8a05dd131f9285468cffe1
$(PKG)_SUBDIR   := mxml-$($(PKG)_VERSION)
$(PKG)_FILE     := mxml-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.minixml.org/
$(PKG)_URL      := http://ftp.easysw.com/pub/mxml/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.minixml.org/software.php' | \
    $(SED) -n 's,.*mxml-\([0-9][^>]*\)\.tar.*,\1,ip' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's, mxmldoc testmxml mxml.xml , ,' '$(1)/Makefile.in'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --disable-threads \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' libmxml.a
    $(TARGET)-ranlib '$(1)/libmxml.a'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libmxml.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/mxml.h' '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/mxml.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig'
endef
