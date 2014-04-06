# This file is part of MXE.
# See index.html for further information.

PKG             := agg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5
$(PKG)_CHECKSUM := 08f23da64da40b90184a0414369f450115cdb328
$(PKG)_SUBDIR   := agg-$($(PKG)_VERSION)
$(PKG)_FILE     := agg-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.antigrain.com/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc freetype sdl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.antigrain.com/download/index.html' | \
    $(SED) -n 's,.*<A href="http://www.antigrain.com/agg-\([0-9.]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,aclocal,aclocal -I $(PREFIX)/$(TARGET)/share/aclocal,' '$(1)/autogen.sh'
    $(SED) -i 's,libtoolize,$(LIBTOOLIZE),'                             '$(1)/autogen.sh'
    cd '$(1)' && $(SHELL) ./autogen.sh \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --without-x
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =
$(PKG)_BUILD_SHARED =
