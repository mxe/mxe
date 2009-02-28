# GLib
# http://www.gtk.org/

PKG            := glib
$(PKG)_VERSION := 2.18.4
$(PKG)_SUBDIR  := glib-$($(PKG)_VERSION)
$(PKG)_FILE    := glib-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL     := http://ftp.gnome.org/pub/gnome/sources/glib/$(word 1,$(subst ., ,$($(PKG)_VERSION))).$(word 2,$(subst ., ,$($(PKG)_VERSION)))/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc gettext pcre libiconv pthreads

define $(PKG)_UPDATE
    wget -q -O- 'http://www.gtk.org/download-windows.html' | \
    grep 'glib-' | \
    $(SED) -n 's,.*glib-\([2-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # native build for glib-genmarshal
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,glib)
    cd '$(1)/$(glib_SUBDIR)' && ./configure \
        --disable-shared \
        --prefix='$(PREFIX)' \
        --enable-regex \
        --without-threads \
        --disable-selinux \
        --disable-fam \
        --disable-xattr
    $(SED) 's,#define G_ATOMIC.*,,' -i '$(1)/$(glib_SUBDIR)/config.h'
    $(MAKE) -C '$(1)/$(glib_SUBDIR)/glib' -j '$(JOBS)'
    $(MAKE) -C '$(1)/$(glib_SUBDIR)/gobject' -j '$(JOBS)' lib_LTLIBRARIES= install-exec
    # cross build
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-threads=win32 \
        --with-pcre=system \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
