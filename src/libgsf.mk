# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# libgsf
PKG             := libgsf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.14.16
$(PKG)_CHECKSUM := 9461d816c283e977d88916932def678560f9c8d5
$(PKG)_SUBDIR   := libgsf-$($(PKG)_VERSION)
$(PKG)_FILE     := libgsf-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://ftp.gnome.org/pub/gnome/sources/libgsf/
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/libgsf/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib bzip2 glib libxml2

define $(PKG)_UPDATE
    wget -q -O- -U 'mingw-cross-env' 'http://freshmeat.net/projects/libgsf/' | \
    grep 'libgsf/releases' | \
    $(SED) -n 's,.*<a href="/projects/libgsf/releases/[^"]*">\([0-9][^<]*\)</a>.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,^\(Requires:.*\),\1 gio-2.0,' -i '$(1)'/libgsf-1.pc.in
    echo 'Libs.private: -lz -lbz2'          >> '$(1)'/libgsf-1.pc.in
    cd '$(1)' && autoconf
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-nls \
        --disable-gtk-doc \
        --disable-schemas-install \
        --without-python \
        --without-gnome-vfs \
        --without-bonobo \
        --with-zlib \
        --with-bz2 \
        --with-gio \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)'     -j '$(JOBS)' install-pkgconfigDATA
    $(MAKE) -C '$(1)/gsf' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
