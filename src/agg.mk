# This file is part of MXE.
# See index.html for further information.

PKG             := agg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5
$(PKG)_CHECKSUM := 08f23da64da40b90184a0414369f450115cdb328
$(PKG)_SUBDIR   := agg-$($(PKG)_VERSION)
$(PKG)_FILE     := agg-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := $(PKG_MIRROR)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc freetype sdl

define $(PKG)_UPDATE
    echo 'TODO: package agg is moving: https://github.com/mxe/mxe/issues/386' >&2;
    echo $(agg_VERSION)
endef

define $(PKG)_UPDATE_OLD
    $(WGET) -q -O- 'http://www.antigrain.com/download/index.html' | \
    $(SED) -n 's,.*<A href="http://www.antigrain.com/agg-\([0-9.]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(foreach f,authors news readme, mv '$(1)/$f' '$(1)/$f_';mv '$(1)/$f_' '$(1)/$(call uc,$f)';)
    cd '$(1)' && autoreconf -fi -I $(PREFIX)/$(TARGET)/share/aclocal
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --without-x
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =
$(PKG)_BUILD_SHARED =
