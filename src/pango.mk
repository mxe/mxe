# Pango

PKG            := pango
$(PKG)_VERSION := 1.24.0
$(PKG)_SUBDIR  := pango-$($(PKG)_VERSION)
$(PKG)_FILE    := pango-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE := http://www.pango.org/
$(PKG)_URL     := http://ftp.gnome.org/pub/gnome/sources/pango/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc fontconfig freetype cairo glib

define $(PKG)_UPDATE
    wget -q -O- 'http://www.gtk.org/download-windows.html' | \
    grep 'pango-' | \
    $(SED) -n 's,.*pango-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,DllMain,static _disabled_DllMain,' -i '$(1)/pango/pango-utils.c'
    $(SED) 's,"[^"]*must build as DLL[^"]*","(disabled warning)",' -i '$(1)/configure'
    $(SED) 's,enable_static=no,enable_static=yes,' -i '$(1)/configure'
    $(SED) 's,enable_shared=yes,enable_shared=no,' -i '$(1)/configure'
    $(SED) 's,^install-data-local:.*,install-data-local:,' -i '$(1)/modules/Makefile.in'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-gtk-doc \
        --without-x \
        --enable-explicit-deps \
        --with-included-modules \
        --without-dynamic-modules
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
