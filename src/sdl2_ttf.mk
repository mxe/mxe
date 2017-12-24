# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sdl2_ttf
$(PKG)_WEBSITE  := https://www.libsdl.org/
$(PKG)_DESCR    := SDL2_ttf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.14
$(PKG)_CHECKSUM := 34db5e20bcf64e7071fe9ae25acaa7d72bdc4f11ab3ce59acc768ab62fe39276
$(PKG)_SUBDIR   := SDL2_ttf-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL2_ttf-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.libsdl.org/projects/SDL_ttf/release/$($(PKG)_FILE)
$(PKG)_DEPS     := cc freetype sdl2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://hg.libsdl.org/SDL_ttf/tags' | \
    $(SED) -n 's,.*release-\([0-9][^<]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    echo 'Requires.private: freetype2' >> '$(1)/SDL2_ttf.pc.in'
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --with-freetype-prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

