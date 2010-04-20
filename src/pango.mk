# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# Pango
PKG             := pango
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.28.0
$(PKG)_CHECKSUM := b77fd452a59e4e11ee8b97193344c945250d5d37
$(PKG)_SUBDIR   := pango-$($(PKG)_VERSION)
$(PKG)_FILE     := pango-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.pango.org/
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/pango/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc fontconfig freetype cairo glib

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/browse/pango/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=\\([0-9][^']*\\)'.*,\\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,DllMain,static _disabled_DllMain,' '$(1)/pango/pango-utils.c'
    $(SED) -i 's,"[^"]*must build as DLL[^"]*","(disabled warning)",' '$(1)/configure'
    $(SED) -i 's,enable_static=no,enable_static=yes,' '$(1)/configure'
    $(SED) -i 's,enable_shared=yes,enable_shared=no,' '$(1)/configure'
    $(SED) -i 's,^install-data-local:.*,install-data-local:,' '$(1)/modules/Makefile.in'
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) -i 's,cross_compiling=no,cross_compiling=yes,' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-gtk-doc \
        --without-x \
        --enable-explicit-deps \
        --with-included-modules \
        --without-dynamic-modules \
        CXX='$(TARGET)-g++'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
