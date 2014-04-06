# This file is part of MXE.
# See index.html for further information.

PKG             := gtkglarea
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.1
$(PKG)_CHECKSUM := db12f2bb9a3d28d69834832e2e04a255acfd8a6d
$(PKG)_SUBDIR   := gtkglarea-$($(PKG)_VERSION)
$(PKG)_FILE     := gtkglarea-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://mirrors.ircam.fr/pub/GNOME/sources/gtkglarea/2.0/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gtk2 freeglut

define $(PKG)_UPDATE
    $(WGET) -q -O- 'mirrors.ircam.fr/pub/GNOME/sources/gtkglarea/2.0' | \
    $(SED) -n 's,.*gtkglarea-\(2[^>]*\)\.tar.*,\1,ip' | \
    sort | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi # to be removed if patch is integrated upstream
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef

$(PKG)_BUILD_SHARED =
