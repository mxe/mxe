# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# libxml2
PKG             := libxml2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.7.8
$(PKG)_CHECKSUM := 859dd535edbb851cc15b64740ee06551a7a17d40
$(PKG)_SUBDIR   := libxml2-$($(PKG)_VERSION)
$(PKG)_FILE     := libxml2-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.xmlsoft.org/
$(PKG)_URL      := ftp://xmlsoft.org/libxml2/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/browse/libxml2/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=v\\([0-9][^']*\\)'.*,\\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,`uname`,MinGW,g' '$(1)/xml2-config.in'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --without-debug \
        --prefix='$(PREFIX)/$(TARGET)' \
        --without-python \
        --without-threads
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
