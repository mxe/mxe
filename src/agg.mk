# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := agg
$(PKG)_WEBSITE  := https://antigrain.com/
$(PKG)_DESCR    := Anti-Grain Geometry
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5
$(PKG)_CHECKSUM := ab1edc54cc32ba51a62ff120d501eecd55fceeedf869b9354e7e13812289911f
$(PKG)_SUBDIR   := agg-$($(PKG)_VERSION)
$(PKG)_FILE     := agg-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://antigrain.com/$($(PKG)_FILE)
$(PKG)_URL_2    := https://web.archive.org/web/20170111090029/www.antigrain.com/$($(PKG)_FILE)
$(PKG)_DEPS     := cc freetype sdl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://antigrain.com/download/index.html' | \
    $(SED) -n 's,.*<A href="https://antigrain.com/agg-\([0-9.]*\).tar.gz".*,\1,p' | \
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
