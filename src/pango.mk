# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

# Pango
PKG             := pango
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.26.2
$(PKG)_CHECKSUM := 051b6f7b5f98a4c8083ef6a5178cb5255a992b98
$(PKG)_SUBDIR   := pango-$($(PKG)_VERSION)
$(PKG)_FILE     := pango-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.pango.org/
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/pango/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc fontconfig freetype cairo glib

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/cgit/pango/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=\\([0-9][^']*\\)'.*,\\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,DllMain,static _disabled_DllMain,' -i '$(1)/pango/pango-utils.c'
    $(SED) 's,"[^"]*must build as DLL[^"]*","(disabled warning)",' -i '$(1)/configure'
    $(SED) 's,enable_static=no,enable_static=yes,' -i '$(1)/configure'
    $(SED) 's,enable_shared=yes,enable_shared=no,' -i '$(1)/configure'
    $(SED) 's,^install-data-local:.*,install-data-local:,' -i '$(1)/modules/Makefile.in'
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) 's,cross_compiling=no,cross_compiling=yes,' -i '$(1)/configure'
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
