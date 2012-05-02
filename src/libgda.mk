# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# LibGDA
PKG             := libgda
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.2.8
$(PKG)_CHECKSUM := 01b859233407407807b2da1c4c244a5907695b7b
$(PKG)_SUBDIR   := libgda-$($(PKG)_VERSION)
$(PKG)_FILE     := libgda-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.gnome-db.org/
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/libgda/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib libxml2 postgresql

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/browse/libgda/refs/tags' | \
    $(SED) -n "s,.*tag/?id=\([0-9]\+\.[0-9]*[02468]\.[^']*\).*,\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --disable-gtk-doc \
        --without-bdb \
        --with-mdb \
        --without-oracle \
        --without-mysql \
        --without-firebird \
        --without-java \
        --enable-binreloc \
        --disable-crypto
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
