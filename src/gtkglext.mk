# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GtkGLExt
PKG             := gtkglext
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.0
$(PKG)_CHECKSUM := db9ce38ee555fd14f55083ec7f4ae30e5338d5cc
$(PKG)_SUBDIR   := gtkglext-$($(PKG)_VERSION)
$(PKG)_FILE     := gtkglext-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://gtkglext.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/gtkglext/gtkglext/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gtk

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/cgit/gtkglext/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=\\([0-9][^']*\\)'.*,\\1,p" | \
    grep -v '1\.1\.' | \
    head -1
endef

define $(PKG)_BUILD
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) -i 's,cross_compiling=no,cross_compiling=yes,' '$(1)/configure'
    # don't require x backend for pango
    $(SED) -i 's,pangox >= 1.0.0,,' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --without-x \
        --disable-gtk-doc \
        --disable-man \
        --disable-glibtest
    $(SED) -i 's, glib-mkenums, $$(GLIB_MKENUMS),' '$(1)/gdk/Makefile'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install \
        bin_PROGRAMS= \
        sbin_PROGRAMS= \
        noinst_PROGRAMS= \
        INFO_DEPS= \
        GDKGLEXT_DEP_CFLAGS='`'$(TARGET)-pkg-config' gtk+-2.0 --cflags`' \
        GTKGLEXT_DEP_CFLAGS='`'$(TARGET)-pkg-config' gtk+-2.0 --cflags`'
endef
