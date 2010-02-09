# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GLib
PKG             := glib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.23.2
$(PKG)_CHECKSUM := 1d4cd02fe775fec5e1b846b31fa4044362c763b5
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
    # native build for glib-genmarshal, without pkg-config, gettext and zlib
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,glib)
    mv '$(1)/$(glib_SUBDIR)' '$(1).native'
    $(SED) 's,gt_cv_have_gettext=yes,gt_cv_have_gettext=no,'     -i '$(1).native/configure'
    $(SED) '/You must.*have gettext/,/exit 1;/ s,.*exit 1;.*,},' -i '$(1).native/configure'
    $(SED) 's,found_zlib=no,found_zlib=yes,'                     -i '$(1).native/configure'
    cd '$(1).native' && ./configure \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-regex \
        --disable-threads \
        --disable-selinux \
        --disable-fam \
        --disable-xattr
    $(SED) 's,#define G_ATOMIC.*,,' -i '$(1).native/config.h'
    $(MAKE) -C '$(1).native/glib'    -j '$(JOBS)'
    $(MAKE) -C '$(1).native/gthread' -j '$(JOBS)'
    $(MAKE) -C '$(1).native/gobject' -j '$(JOBS)' lib_LTLIBRARIES= install-exec

    # cross build
    cd '$(1)' && aclocal
    cd '$(1)' && $(LIBTOOLIZE) --force
    cd '$(1)' && autoconf
    $(SED) 's,^\(Libs:.*\),\1 @PCRE_LIBS@ @G_THREAD_LIBS@ @G_LIBS_EXTRA@ -lshlwapi,' -i '$(1)/glib-2.0.pc.in'
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) 's,cross_compiling=no,cross_compiling=yes,' -i '$(1)/configure'
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
