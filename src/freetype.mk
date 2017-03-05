# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := freetype
$(PKG)_WEBSITE  := https://www.freetype.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.7
$(PKG)_CHECKSUM := d6a451f5b754857d2aa3964fd4473f8bc5c64e879b24516d780fb26bec7f7d48
$(PKG)_SUBDIR   := freetype-$($(PKG)_VERSION)
$(PKG)_FILE     := freetype-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/freetype/freetype2/$(shell echo '$($(PKG)_VERSION)' | cut -d . -f 1,2,3)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc bzip2 harfbuzz libpng zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/freetype/files/freetype2/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD_COMMON
    cd '$(1)' && GNUMAKE=$(MAKE) ./configure \
        $(MXE_CONFIGURE_OPTS) \
        LIBPNG_CFLAGS="`$(TARGET)-pkg-config libpng --cflags`" \
        LIBPNG_LDFLAGS="`$(TARGET)-pkg-config libpng --libs`" \
        FT2_EXTRA_LIBS="`$(TARGET)-pkg-config libpng --libs`" \
        $(if $(BUILD_STATIC),HARFBUZZ_LIBS="`$(TARGET)-pkg-config harfbuzz --libs` -lharfbuzz_too `$(TARGET)-pkg-config glib-2.0 --libs`",)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
    ln -sf '$(PREFIX)/$(TARGET)/bin/freetype-config' '$(PREFIX)/bin/$(TARGET)-freetype-config'
endef

define $(PKG)_BUILD
    # alias harfbuzz to handle linking circularity
    $(if $(BUILD_STATIC),\
        ln -sf libharfbuzz.a '$(PREFIX)/$(TARGET)/lib/libharfbuzz_too.a',)
    $($(PKG)_BUILD_COMMON)
endef
