# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libxml2
$(PKG)_WEBSITE  := http://xmlsoft.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.13.4
$(PKG)_CHECKSUM := 65d042e1c8010243e617efb02afda20b85c2160acdbfbcb5b26b80cec6515650
$(PKG)_SUBDIR   := libxml2-$($(PKG)_VERSION)
$(PKG)_FILE     := libxml2-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/libxml2/2.13/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftp.osuosl.org/pub/blfs/conglomeration/libxml2/$($(PKG)_FILE)
$(PKG)_DEPS     := cc xz zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/libxml2/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\([0-9,\.]\+\)<.*,\\1,p" | \
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

    '$(TARGET)-g++' \
        -mwindows -W -Wall -Werror -Wno-error=deprecated-declarations \
        -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-librsvg.exe' \
        `'$(TARGET)-pkg-config' librsvg-2.0 --cflags --libs` \
        -lbcrypt
endef
