# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# libgsf
PKG             := libgsf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.14.21
$(PKG)_CHECKSUM := 17981f238f1f8dddb7af01c161bd6a1c4d5e85d2
$(PKG)_SUBDIR   := libgsf-$($(PKG)_VERSION)
$(PKG)_FILE     := libgsf-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://ftp.gnome.org/pub/gnome/sources/libgsf/
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/libgsf/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib bzip2 glib libxml2

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/browse/libgsf/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=LIBGSF_\\([0-9]*_[0-9]*[02468]_[^<]*\\)'.*,\\1,p" | \
    $(SED) 's,_,.,g' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,^\(Requires:.*\),\1 gio-2.0,' '$(1)'/libgsf-1.pc.in
    echo 'Libs.private: -lz -lbz2'          >> '$(1)'/libgsf-1.pc.in
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
