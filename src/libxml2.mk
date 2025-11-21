# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libxml2
$(PKG)_WEBSITE  := http://xmlsoft.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.14.6
$(PKG)_CHECKSUM := 7ce458a0affeb83f0b55f1f4f9e0e55735dbfc1a9de124ee86fb4a66b597203a
$(PKG)_SUBDIR   := libxml2-$($(PKG)_VERSION)
$(PKG)_FILE     := libxml2-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/libxml2/2.14/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftp.osuosl.org/pub/blfs/conglomeration/libxml2/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libiconv xz zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/libxml2/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\([0-9,\.]\+\)<.*,\\1,p" | \
    $(SORT) -Vr | head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        $(if $(BUILD_STATIC), \
          --disable-pixbuf-loader,) \
        --disable-gtk-doc \
        --enable-introspection=no
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-g++' \
        -mwindows -W -Wall -Werror -Wno-error=deprecated-declarations \
        -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-librsvg.exe' \
        `'$(TARGET)-pkg-config' librsvg-2.0 --cflags --libs` \
        -lbcrypt
endef
