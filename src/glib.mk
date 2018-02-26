# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := glib
$(PKG)_WEBSITE  := https://gtk.org/
$(PKG)_DESCR    := GLib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.50.2
$(PKG)_CHECKSUM := be68737c1f268c05493e503b3b654d2b7f43d7d0b8c5556f7e4651b870acfbf5
$(PKG)_SUBDIR   := glib-$($(PKG)_VERSION)
$(PKG)_FILE     := glib-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/glib/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc dbus gettext libffi libiconv pcre zlib $(BUILD)~$(PKG)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

$(PKG)_DEPS_$(BUILD) := autotools gettext libiconv zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://git.gnome.org/browse/glib/refs/tags' | \
    $(SED) -n "s,.*glib-\([0-9]\+\.[0-9]*[02468]\.[^']*\)\.tar.*,\1,p" | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD_DARWIN
    # native build for glib-tools
    # libiconv/gettext cause issues with other packages so build inline
    mkdir '$(BUILD_DIR).src'
    $(call PREPARE_PKG_SOURCE,libiconv,$(BUILD_DIR).src)
    cd '$(BUILD_DIR).src/$(libiconv_SUBDIR)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --prefix='$(BUILD_DIR).usr'
    $(MAKE) -C '$(BUILD_DIR).src/$(libiconv_SUBDIR)' -j '$(JOBS)' $(MXE_DISABLE_DOCS)
    $(MAKE) -C '$(BUILD_DIR).src/$(libiconv_SUBDIR)' -j 1 install $(MXE_DISABLE_DOCS)

    $(call PREPARE_PKG_SOURCE,gettext,$(BUILD_DIR).src)
    cd '$(BUILD_DIR).src/$(gettext_SUBDIR)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --prefix='$(BUILD_DIR).usr'
    $(MAKE) -C '$(BUILD_DIR).src/$(gettext_SUBDIR)' -j '$(JOBS)' $(MXE_DISABLE_DOCS)
    $(MAKE) -C '$(BUILD_DIR).src/$(gettext_SUBDIR)' -j 1 install $(MXE_DISABLE_DOCS)

    cd '$(SOURCE_DIR)' && NOCONFIGURE=true ./autogen.sh
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --enable-regex \
        --disable-threads \
        --disable-selinux \
        --disable-inotify \
        --disable-fam \
        --disable-xattr \
        --disable-dtrace \
        --disable-libmount \
        --with-pcre=internal \
        CPPFLAGS='-I$(BUILD_DIR).usr/include' \
        LDFLAGS='-L$(BUILD_DIR).usr/lib'
    $(MAKE) -C '$(BUILD_DIR)/glib'    -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)/gthread' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)/gmodule' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)/gobject' -j '$(JOBS)' lib_LTLIBRARIES= install-exec
    $(MAKE) -C '$(BUILD_DIR)/gio/xdgmime'     -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)/gio/kqueue'      -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)/gio'     -j '$(JOBS)' glib-compile-schemas
    $(MAKE) -C '$(BUILD_DIR)/gio'     -j '$(JOBS)' glib-compile-resources
    $(INSTALL) -m755 '$(BUILD_DIR)/gio/glib-compile-schemas' '$(PREFIX)/$(TARGET)/bin/'
    $(INSTALL) -m755 '$(BUILD_DIR)/gio/glib-compile-resources' '$(PREFIX)/$(TARGET)/bin/'
endef

define $(PKG)_BUILD_NATIVE
    # native build for glib-tools
    cd '$(SOURCE_DIR)' && NOCONFIGURE=true ./autogen.sh
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --enable-regex \
        --disable-threads \
        --disable-selinux \
        --disable-inotify \
        --disable-fam \
        --disable-xattr \
        --disable-dtrace \
        --disable-libmount \
        --with-libiconv=gnu \
        --with-pcre=internal \
        CPPFLAGS='-I$(PREFIX)/$(TARGET)/include' \
        LDFLAGS='-L$(PREFIX)/$(TARGET)/lib'
    $(SED) -i 's,#define G_ATOMIC.*,,' '$(BUILD_DIR)/config.h'
    $(MAKE) -C '$(BUILD_DIR)/glib'    -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)/gthread' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)/gmodule' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)/gobject' -j '$(JOBS)' lib_LTLIBRARIES= install-exec
    $(MAKE) -C '$(BUILD_DIR)/gio/xdgmime'     -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)/gio'     -j '$(JOBS)' glib-compile-schemas
    $(MAKE) -C '$(BUILD_DIR)/gio'     -j '$(JOBS)' glib-compile-resources
    $(INSTALL) -m755 '$(BUILD_DIR)/gio/glib-compile-schemas' '$(PREFIX)/$(TARGET)/bin/'
    $(INSTALL) -m755 '$(BUILD_DIR)/gio/glib-compile-resources' '$(PREFIX)/$(TARGET)/bin/'
endef

define $(PKG)_BUILD_$(BUILD)
    # glib tools need to be close to glib-cross version.
    # easy to build on linux, but error-prone on darwin (and freebsd?)
    $(if $(findstring darwin, $(BUILD)), \
        $($(PKG)_BUILD_DARWIN), \
        $($(PKG)_BUILD_NATIVE))
endef

define $(PKG)_BUILD
    # other packages expect glib-tools in $(TARGET)/bin
    rm -f  '$(PREFIX)/$(TARGET)/bin/glib-*'
    ln -sf '$(PREFIX)/$(BUILD)/bin/glib-genmarshal'        '$(PREFIX)/$(TARGET)/bin/'
    ln -sf '$(PREFIX)/$(BUILD)/bin/glib-compile-schemas'   '$(PREFIX)/$(TARGET)/bin/'
    ln -sf '$(PREFIX)/$(BUILD)/bin/glib-compile-resources' '$(PREFIX)/$(TARGET)/bin/'

    # cross build
    cd '$(SOURCE_DIR)' && NOCONFIGURE=true ./autogen.sh
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --with-threads=win32 \
        --with-pcre=system \
        --with-libiconv=gnu \
        --disable-inotify \
        CXX='$(TARGET)-g++' \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        GLIB_GENMARSHAL='$(PREFIX)/$(TARGET)/bin/glib-genmarshal' \
        GLIB_COMPILE_SCHEMAS='$(PREFIX)/$(TARGET)/bin/glib-compile-schemas' \
        GLIB_COMPILE_RESOURCES='$(PREFIX)/$(TARGET)/bin/glib-compile-resources'
    $(MAKE) -C '$(BUILD_DIR)/glib'    -j '$(JOBS)' install sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(BUILD_DIR)/gmodule' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(BUILD_DIR)/gthread' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(BUILD_DIR)/gobject' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(BUILD_DIR)/gio'     -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= MISC_STUFF=
    $(MAKE) -C '$(BUILD_DIR)'         -j '$(JOBS)' install-pkgconfigDATA
    $(MAKE) -C '$(BUILD_DIR)/m4macros' install
endef
