# This file is part of MXE.
# See index.html for further information.

PKG             := glib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.42.1
$(PKG)_CHECKSUM := b5158fd434f01e84259155c04ff93026a090e586
$(PKG)_SUBDIR   := glib-$($(PKG)_VERSION)
$(PKG)_FILE     := glib-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/glib/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gettext pcre libiconv zlib libffi dbus

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.gnome.org/browse/glib/refs/tags' | \
    $(SED) -n "s,.*tag/?id=\([0-9]\+\.[0-9]*[02468]\.[^']*\).*,\1,p" | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_NATIVE_BUILD
    cp -Rp '$(1)' '$(1).native'

    # native build of libiconv (used by glib-genmarshal)
    cd '$(1).native' && $(call UNPACK_PKG_ARCHIVE,libiconv)
    $(foreach PKG_PATCH,$(sort $(wildcard $(TOP_DIR)/src/libiconv-*.patch)),
        (cd '$(1).native/$(libiconv_SUBDIR)' && $(PATCH) -p1 -u) < $(PKG_PATCH))
    cd '$(1).native/$(libiconv_SUBDIR)' && ./configure \
        --disable-shared \
        --disable-nls
    $(MAKE) -C '$(1).native/$(libiconv_SUBDIR)' -j '$(JOBS)'

    # native build for glib-genmarshal, without gettext and zlib
    cd '$(1).native' && ./configure \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-regex \
        --disable-threads \
        --disable-selinux \
        --disable-inotify \
        --disable-fam \
        --disable-xattr \
        --disable-dtrace \
        --with-libiconv=gnu \
        --with-pcre=internal \
        CPPFLAGS='-I$(1).native/$(libiconv_SUBDIR)/include' \
        LDFLAGS='-L$(1).native/$(libiconv_SUBDIR)/lib/.libs'
    $(SED) -i 's,#define G_ATOMIC.*,,' '$(1).native/config.h'
    $(MAKE) -C '$(1).native/glib'    -j '$(JOBS)'
    $(MAKE) -C '$(1).native/gthread' -j '$(JOBS)'
    $(MAKE) -C '$(1).native/gmodule' -j '$(JOBS)'
    $(MAKE) -C '$(1).native/gobject' -j '$(JOBS)' lib_LTLIBRARIES= install-exec
    $(MAKE) -C '$(1).native/gio/xdgmime'     -j '$(JOBS)'
    $(MAKE) -C '$(1).native/gio'     -j '$(JOBS)' glib-compile-schemas
    $(MAKE) -C '$(1).native/gio'     -j '$(JOBS)' glib-compile-resources
    $(INSTALL) -m755 '$(1).native/gio/glib-compile-schemas' '$(PREFIX)/$(TARGET)/bin/'
    $(INSTALL) -m755 '$(1).native/gio/glib-compile-resources' '$(PREFIX)/$(TARGET)/bin/'
endef

define $(PKG)_SYMLINK
    ln -sf `which glib-genmarshal`        '$(PREFIX)/$(TARGET)/bin/'
    ln -sf `which glib-compile-schemas`   '$(PREFIX)/$(TARGET)/bin/'
    ln -sf `which glib-compile-resources` '$(PREFIX)/$(TARGET)/bin/'
endef

define $(PKG)_BUILD
    cd '$(1)' && NOCONFIGURE=true ./autogen.sh
    rm -f '$(PREFIX)/$(TARGET)/bin/glib-*'

    # Detecting if these GLib tools are already available on host machine,
    # either because of a host package installation or from an earlier MXE
    # installation of GLib.
    # If it is installed, we symlink it into the MXE bin/.
    # If not, we build it.
    $(if $(findstring y,\
            $(shell [ -x "`which glib-genmarshal`" ] && \
                    [ -x "`which glib-compile-schemas`" ] && \
                    [ -x "`which glib-compile-resources`" ] && echo y)), \
        $($(PKG)_SYMLINK), \
        $($(PKG)_NATIVE_BUILD))

    # cross build
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-threads=win32 \
        --with-pcre=system \
        --with-libiconv=gnu \
        --disable-inotify \
        CXX='$(TARGET)-g++' \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        GLIB_GENMARSHAL='$(PREFIX)/$(TARGET)/bin/glib-genmarshal' \
        GLIB_COMPILE_SCHEMAS='$(PREFIX)/$(TARGET)/bin/glib-compile-schemas' \
        GLIB_COMPILE_RESOURCES='$(PREFIX)/$(TARGET)/bin/glib-compile-resources' \
        $(if $(findstring w64-mingw32,$(TARGET)),  CFLAGS="-DHAVE_IF_NAMETOINDEX=1")
    $(MAKE) -C '$(1)/glib'    -j '$(JOBS)' install sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)/gmodule' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)/gthread' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)/gobject' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)/gio'     -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= MISC_STUFF=
    $(MAKE) -C '$(1)'         -j '$(JOBS)' install-pkgconfigDATA
    $(MAKE) -C '$(1)/m4macros' install
endef
