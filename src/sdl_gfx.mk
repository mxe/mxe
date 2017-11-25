# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sdl_gfx
$(PKG)_WEBSITE  := http://www.ferzkopp.net/joomla/content/view/19/14/
$(PKG)_DESCR    := SDL_gfx
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.25
$(PKG)_CHECKSUM := 556eedc06b6cf29eb495b6d27f2dcc51bf909ad82389ba2fa7bdc4dec89059c0
$(PKG)_SUBDIR   := SDL_gfx-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_gfx-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.ferzkopp.net/Software/SDL_gfx-2.0/$($(PKG)_FILE)
$(PKG)_DEPS     := cc sdl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.ferzkopp.net/joomla/content/view/19/14/' | \
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
