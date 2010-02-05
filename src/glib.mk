# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

# GLib
PKG             := glib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.23.1
$(PKG)_CHECKSUM := 2cf7af4f0a4ac9b4f2b9e95661d94985e64c7c5e
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
    # native build of libiconv (used by glib-genmarshal)
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,libiconv)
    cd '$(1)/$(libiconv_SUBDIR)' && ./configure \
        --prefix='$(1)/libiconv' \
        --disable-shared \
        --disable-nls
    $(MAKE) -C '$(1)/$(libiconv_SUBDIR)' -j 1 install

    # native build for glib-genmarshal, without pkg-config, gettext, and zlib
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,glib)
    $(SED) 's,^PKG_CONFIG=.*,PKG_CONFIG=echo,' -i '$(1)/$(glib_SUBDIR)/configure'
    $(SED) 's,gt_cv_have_gettext=yes,gt_cv_have_gettext=no,' -i '$(1)/$(glib_SUBDIR)/configure'
    $(SED) '/You must.*have gettext/,/exit 1;/ s,.*exit 1;.*,},' -i '$(1)/$(glib_SUBDIR)/configure'
    $(SED) 's,found_zlib=no,found_zlib=yes,' -i '$(1)/$(glib_SUBDIR)/configure'

    cd '$(1)/$(glib_SUBDIR)' && ./configure \
        --disable-shared \
        --prefix='$(PREFIX)' \
        --enable-regex \
        --without-threads \
        --disable-selinux \
        --disable-fam \
        --disable-xattr \
        --with-libiconv=gnu \
        CPPFLAGS='-I$(1)/libiconv/include' \
        LDFLAGS='-L$(1)/libiconv/lib'
    $(SED) 's,#define G_ATOMIC.*,,' -i '$(1)/$(glib_SUBDIR)/config.h'
    $(MAKE) -C '$(1)/$(glib_SUBDIR)/glib' -j '$(JOBS)'
    $(MAKE) -C '$(1)/$(glib_SUBDIR)/gobject' -j '$(JOBS)' lib_LTLIBRARIES= install-exec

    # cross build
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
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
