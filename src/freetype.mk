# This file is part of MXE.
# See index.html for further information.

PKG             := freetype
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5.3
$(PKG)_CHECKSUM := d3c26cc17ec7fe6c36f4efc02ef92ab6aa3f4b46
$(PKG)_SUBDIR   := freetype-$($(PKG)_VERSION)
$(PKG)_FILE     := freetype-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/freetype/freetype2/$(shell echo '$($(PKG)_VERSION)' | cut -d . -f 1,2,3)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc bzip2 harfbuzz libpng zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/freetype/files/freetype2/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    # alias harfbuzz to handle linking circularity
    $(if $(BUILD_STATIC),\
        ln -sf libharfbuzz.a '$(PREFIX)/$(TARGET)/lib/libharfbuzz_too.a',)
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
