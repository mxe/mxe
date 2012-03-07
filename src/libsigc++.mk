# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# libsigc++
PKG             := libsigc++
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.10
$(PKG)_CHECKSUM := 240d3e0a02e764a6362f6ce1b32de71401e50844
$(PKG)_SUBDIR   := libsigc++-$($(PKG)_VERSION)
$(PKG)_FILE     := libsigc++-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://libsigc.sourceforge.net/
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/libsigc++/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/browse/libsigc++2/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9][^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        CXX='$(TARGET)-c++' \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
