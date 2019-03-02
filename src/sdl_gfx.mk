# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sdl_gfx
$(PKG)_WEBSITE  := https://www.ferzkopp.net/joomla/content/view/19/14/
$(PKG)_DESCR    := SDL_gfx
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.26
$(PKG)_CHECKSUM := 7ceb4ffb6fc63ffba5f1290572db43d74386cd0781c123bc912da50d34945446
$(PKG)_SUBDIR   := SDL_gfx-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_gfx-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.ferzkopp.net/Software/SDL_gfx-2.0/$($(PKG)_FILE)
$(PKG)_DEPS     := cc sdl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.ferzkopp.net/joomla/content/view/19/14/' | \
    grep 'href.*tar\.' | \
    $(SED) -n 's,.*SDL_gfx-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-sdl_gfx.exe' \
        `'$(TARGET)-pkg-config' SDL_gfx --cflags --libs`
endef
