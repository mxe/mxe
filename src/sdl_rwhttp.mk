# This file is part of MXE.
# See index.html for further information.

PKG             := sdl_rwhttp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.2.0
$(PKG)_CHECKSUM := 9341f427901b5d24d07fd74c8a9124b3c363669142cdf0b3675ac72afe793ea1
$(PKG)_SUBDIR   := SDL_rwhttp-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_rwhttp-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/mgerhardy/SDL_rwhttp/releases/download/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc curl sdl2 sdl2_net

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://github.com/mgerhardy/SDL_rwhttp/tags' | \
    grep '<a href="/mgerhardy/SDL_rwhttp/archive/' | \
    $(SED) -n 's,.*href="/mgerhardy/SDL_rwhttp/archive/\([0-9][^"_]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        WINDRES='$(TARGET)-windres'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

#    '$(TARGET)-gcc' \
#        -W -Wall -Werror -ansi -pedantic \
#        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-sdl_rwhttp.exe' \
#        `'$(TARGET)-pkg-config' SDL_rwhttp --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
