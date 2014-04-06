# This file is part of MXE.
# See index.html for further information.

PKG             := exiv2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.24
$(PKG)_CHECKSUM := 2f19538e54f8c21c180fa96d17677b7cff7dc1bb
$(PKG)_SUBDIR   := exiv2-$($(PKG)_VERSION)
$(PKG)_FILE     := exiv2-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.exiv2.org/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gettext zlib expat

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.exiv2.org/download.html' | \
    grep 'href="exiv2-' | \
    $(SED) -n 's,.*exiv2-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-visibility \
        --disable-nls \
        --with-expat
    $(MAKE) -C '$(1)/xmpsdk/src' -j '$(JOBS)'
    $(MAKE) -C '$(1)/src'        -j '$(JOBS)' install-lib
endef

$(PKG)_BUILD_SHARED =
