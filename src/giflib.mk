# This file is part of MXE.
# See index.html for further information.

PKG             := giflib
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 98477ca6224e3f42e443255a93c5c86d0723e2d6
$(PKG)_SUBDIR   := giflib-$($(PKG)_VERSION)
$(PKG)_FILE     := giflib-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/giflib/giflib-5.x/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://giflib.git.sourceforge.net/git/gitweb.cgi?p=giflib/giflib;a=tags' | \
    grep '<a class="list name"' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9][^<]*\)<.*,\1,p' | \
    grep -v alpha | \
    grep -v beta | \
    grep -v rc | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        CPPFLAGS='-D_OPEN_BINARY'
    echo 'all:' > '$(1)/doc/Makefile'
    $(MAKE) -C '$(1)/lib' -j '$(JOBS)' install
endef
