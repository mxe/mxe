# This file is part of MXE.
# See index.html for further information.

PKG             := exiv2
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 35211d853a986fe1b008fca14db090726e8dcce3
$(PKG)_SUBDIR   := exiv2-$($(PKG)_VERSION)
$(PKG)_FILE     := exiv2-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.exiv2.org/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv zlib expat

define $(PKG)_UPDATE
    wget -q -O- 'http://www.exiv2.org/download.html' | \
    grep 'href="exiv2-' | \
    $(SED) -n 's,.*exiv2-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        $(LINK_STYLE) \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-visibility \
        --disable-nls \
        --with-expat
    $(MAKE) -C '$(1)/xmpsdk/src' -j '$(JOBS)'
    $(MAKE) -C '$(1)/src'        -j '$(JOBS)' install-lib
endef
