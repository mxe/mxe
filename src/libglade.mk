# This file is part of MXE.
# See index.html for further information.

PKG             := libglade
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.6.4
$(PKG)_CHECKSUM := 3cc65ed13c10025780488935313329170baa33c6
$(PKG)_SUBDIR   := libglade-$($(PKG)_VERSION)
$(PKG)_FILE     := libglade-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnome.org/pub/GNOME/sources/libglade/2.6/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libxml2 atk glib gtk2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnome.org/pub/GNOME/sources/libglade/2.6/' | \
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
