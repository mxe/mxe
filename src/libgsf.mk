# This file is part of MXE.
# See index.html for further information.

PKG             := libgsf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.14.30
$(PKG)_CHECKSUM := 5eb15d574c6b9e9c5e63bbcdff8f866b3544485a
$(PKG)_SUBDIR   := libgsf-$($(PKG)_VERSION)
$(PKG)_FILE     := libgsf-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/libgsf/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib bzip2 glib libxml2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.gnome.org/browse/libgsf/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=LIBGSF_\\([0-9]*_[0-9]*[02468]_[^<]*\\)'.*,\\1,p" | \
    $(SED) 's,_,.,g' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,^\(Requires:.*\),\1 gio-2.0,' '$(1)'/libgsf-1.pc.in
    echo 'Libs.private: -lz -lbz2'          >> '$(1)'/libgsf-1.pc.in
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-nls \
        --disable-gtk-doc \
        --without-python \
        --with-zlib \
        --with-bz2 \
        --with-gio \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)'     -j '$(JOBS)' install-pkgconfigDATA
    $(MAKE) -C '$(1)/gsf' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
