# This file is part of MXE.
# See index.html for further information.

PKG             := libharu
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := b75ec6052b8d72aa7f23d67adcdf9df4847b64ca
$(PKG)_SUBDIR   := libharu-$($(PKG)_VERSION)
$(PKG)_FILE     := libharu-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://libharu.org/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib libpng

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/libharu/libharu/tags' | \
    $(SED) -n 's,.*/archive/RELEASE_\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SED) 's,_,.,g' | \
    grep -v 'RC' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --with-zlib='$(PREFIX)/$(TARGET)' \
        --with-png='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
