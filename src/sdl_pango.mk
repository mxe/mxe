# This file is part of MXE.
# See index.html for further information.

PKG             := sdl_pango
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.2
$(PKG)_CHECKSUM := c30f2941d476d9362850a150d29cb4a93730af68
$(PKG)_SUBDIR   := SDL_Pango-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_Pango-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/sdlpango/SDL_Pango/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sdl pango

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/sdlpango/files/SDL_Pango/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,\r$$,,'                        '$(1)/SDL_Pango.pc.in'
    $(SED) -i 's,^\(Requires:.*\),\1 pangoft2,' '$(1)/SDL_Pango.pc.in'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        PKG_CONFIG='$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

$(PKG)_BUILD_SHARED =
