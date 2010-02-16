# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GLib
PKG             := glib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.23.3
$(PKG)_CHECKSUM := 9ba908954fbcab7f8b74faf483f83b7ef8d28cf9
$(PKG)_SUBDIR   := glib-$($(PKG)_VERSION)
$(PKG)_FILE     := glib-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.gtk.org/
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/glib/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gettext pcre libiconv zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/cgit/glib/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=\\([0-9][^']*\\)'.*,\\1,p" | \
    grep -v '2\.22\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,glib)
    mv '$(1)/$(glib_SUBDIR)' '$(1).native'

    # native build of libiconv (used by glib-genmarshal)
    cd '$(1).native' && $(call UNPACK_PKG_ARCHIVE,libiconv)
    cd '$(1).native/$(libiconv_SUBDIR)' && ./configure \
        --disable-shared \
        --disable-nls
    $(MAKE) -C '$(1).native/$(libiconv_SUBDIR)' -j '$(JOBS)'

    # native build for glib-genmarshal, without pkg-config, gettext and zlib
    $(SED) -i 's,gt_cv_have_gettext=yes,gt_cv_have_gettext=no,'     '$(1).native/configure'
    $(SED) -i '/You must.*have gettext/,/exit 1;/ s,.*exit 1;.*,},' '$(1).native/configure'
    $(SED) -i 's,found_zlib=no,found_zlib=yes,'                     '$(1).native/configure'
    cd '$(1).native' && ./configure \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-regex \
        --disable-threads \
        --disable-selinux \
        --disable-fam \
        --disable-xattr \
        --with-libiconv=gnu \
        CPPFLAGS='-I$(1).native/$(libiconv_SUBDIR)/include' \
        LDFLAGS='-L$(1).native/$(libiconv_SUBDIR)/lib/.libs'
    $(SED) -i 's,#define G_ATOMIC.*,,' '$(1).native/config.h'
    $(MAKE) -C '$(1).native/glib'    -j '$(JOBS)'
    $(MAKE) -C '$(1).native/gthread' -j '$(JOBS)'
    $(MAKE) -C '$(1).native/gobject' -j '$(JOBS)' lib_LTLIBRARIES= install-exec

    # cross build
    cd '$(1)' && aclocal
    cd '$(1)' && $(LIBTOOLIZE) --force
    cd '$(1)' && autoconf
    $(SED) -i 's,^\(Libs:.*\),\1 @PCRE_LIBS@ @G_THREAD_LIBS@ @G_LIBS_EXTRA@ -lshlwapi,' '$(1)/glib-2.0.pc.in'
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) -i 's,cross_compiling=no,cross_compiling=yes,' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-threads=win32 \
        --with-pcre=system \
        --with-libiconv=gnu \
        CXX='$(TARGET)-c++' \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        GLIB_GENMARSHAL='$(PREFIX)/$(TARGET)/bin/glib-genmarshal'
    $(MAKE) -C '$(1)/glib'    -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)/gmodule' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)/gthread' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)/gobject' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)/gio'     -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)'         -j '$(JOBS)' install-pkgconfigDATA install-configexecincludeDATA
endef
