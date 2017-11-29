# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := freetype
$(PKG)_DEPS     := gcc bzip2 libpng zlib

define $(PKG)_BUILD_COMMON
    cd '$(1)' && GNUMAKE=$(MAKE) ./configure --with-harfbuzz=no \
        $(MXE_CONFIGURE_OPTS) \
        LIBPNG_CFLAGS="`$(TARGET)-pkg-config libpng --cflags`" \
        LIBPNG_LDFLAGS="`$(TARGET)-pkg-config libpng --libs`" \
        FT2_EXTRA_LIBS="`$(TARGET)-pkg-config libpng --libs`"
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
    ln -sf '$(PREFIX)/$(TARGET)/bin/freetype-config' '$(PREFIX)/bin/$(TARGET)-freetype-config'
endef

define $(PKG)_BUILD
    $($(PKG)_BUILD_COMMON)
endef
