# This file is part of MXE.
# See index.html for further information.

PKG             := t4k_common
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.1
$(PKG)_CHECKSUM := 42c155816dae2c5dad560faa50edaa1ca84536530283d37859c4b91e82675110
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/tuxmath/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libpng librsvg libxml2 pthreads sdl sdl_image sdl_mixer sdl_net sdl_pango sdl_ttf

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://alioth.debian.org/frs/?group_id=31080' | \
    $(SED) -n 's,.*t4k_common-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-sdlpango \
        --with-sdlnet \
        --with-rsvg
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

$(PKG)_BUILD_SHARED =
