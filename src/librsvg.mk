# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := librsvg
$(PKG)_WEBSITE  := https://librsvg.sourceforge.io/
$(PKG)_IGNORE   :=
# 2.40 branch is the last one using pure C. Later started using rust.
$(PKG)_VERSION  := 2.40.21
$(PKG)_CHECKSUM := f7628905f1cada84e87e2b14883ed57d8094dca3281d5bcb24ece4279e9a92ba
$(PKG)_SUBDIR   := librsvg-$($(PKG)_VERSION)
$(PKG)_FILE     := librsvg-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/librsvg/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc cairo gdk-pixbuf glib libcroco libgsf pango

# TODO: limit versions to librsvg-2.40 branch
define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/librsvg/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\?\([0-9]\+\.[0-9.]\+\)<.*,\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        $(if $(BUILD_STATIC), \
          --disable-pixbuf-loader,) \
        --disable-gtk-doc \
        --enable-introspection=no
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -mwindows -W -Wall -Werror -Wno-error=deprecated-declarations \
        -std=c99 -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-librsvg.exe' \
        `'$(TARGET)-pkg-config' librsvg-2.0 --cflags --libs`
endef
