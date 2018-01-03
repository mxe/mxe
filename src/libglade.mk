# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libglade
$(PKG)_WEBSITE  := https://glade.gnome.org/
$(PKG)_DESCR    := glade
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.6.4
$(PKG)_CHECKSUM := c41d189b68457976069073e48d6c14c183075d8b1d8077cb6dfb8b7c5097add3
$(PKG)_SUBDIR   := libglade-$($(PKG)_VERSION)
$(PKG)_FILE     := libglade-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://download.gnome.org/sources/libglade/2.6/$($(PKG)_FILE)
$(PKG)_DEPS     := cc atk glib gtk2 libxml2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://download.gnome.org/sources/libglade/2.6/' | \
    $(SED) -n 's,.*"libglade-\([0-9][^"]*\)\.tar.gz.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi -I'$(PREFIX)/$(TARGET)/share/aclocal'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

$(PKG)_BUILD_SHARED =
