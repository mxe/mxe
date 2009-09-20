# Copyright (C) 2009  Volker Grabsch
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject
# to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# GLib
PKG             := glib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.20.5
$(PKG)_CHECKSUM := 19e2b2684d7bc35a73ff94eb7fd15fc70cc6f292
$(PKG)_SUBDIR   := glib-$($(PKG)_VERSION)
$(PKG)_FILE     := glib-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.gtk.org/
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/glib/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gettext pcre libiconv

define $(PKG)_UPDATE
    wget -q -O- 'http://www.gtk.org/download-windows.html' | \
    grep 'glib-' | \
    $(SED) -n 's,.*glib-\([0-9][^>]*\)\.tar.*,\1,p' | \
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

    # native build for glib-genmarshal, without pkg-config and gettext
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,glib)
    $(SED) 's,^PKG_CONFIG=.*,PKG_CONFIG=echo,' -i '$(1)/$(glib_SUBDIR)/configure'
    $(SED) 's,gt_cv_have_gettext=yes,gt_cv_have_gettext=no,' -i '$(1)/$(glib_SUBDIR)/configure'
    $(SED) '/You must.*have gettext/,/exit 1;/ s,.*exit 1;.*,},' -i '$(1)/$(glib_SUBDIR)/configure'
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
