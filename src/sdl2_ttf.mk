# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sdl2_ttf
$(PKG)_WEBSITE  := https://www.libsdl.org/
$(PKG)_DESCR    := SDL2_ttf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.18
$(PKG)_CHECKSUM := 6b61544441b72bdfa1ced89034c6396fe80228eff201eb72c5f78e500bb80bd0
$(PKG)_GH_CONF  := libsdl-org/SDL_ttf/releases/tag,release-,,
$(PKG)_DEPS     := cc freetype harfbuzz sdl2

define $(PKG)_BUILD
    echo 'Requires.private: harfbuzz freetype2' >> '$(1)/SDL2_ttf.pc.in'
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --with-freetype-prefix='$(PREFIX)/$(TARGET)' \
        --disable-freetype-builtin \
        --disable-harfbuzz-builtin
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

