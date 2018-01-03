# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gtkglarea
$(PKG)_WEBSITE  := http://www.mono-project.com/GtkGLArea/
$(PKG)_DESCR    := GtkGLArea
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.1
$(PKG)_CHECKSUM := dffe1cc0512d20d3840d0a1f3eff727bf2207c5c6714125155ca0cee0b177179
$(PKG)_SUBDIR   := gtkglarea-$($(PKG)_VERSION)
$(PKG)_FILE     := gtkglarea-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://mirrors.ircam.fr/pub/GNOME/sources/gtkglarea/2.0/$($(PKG)_FILE)
$(PKG)_DEPS     := cc freeglut gtk2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://mirrors.ircam.fr/pub/GNOME/sources/gtkglarea/2.0' | \
    $(SED) -n 's,.*gtkglarea-\(2[^>]*\)\.tar.*,\1,ip' | \
    $(SORT) | \
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
