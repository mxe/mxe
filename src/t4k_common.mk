# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# t4k_common
PKG             := t4k_common
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.1
$(PKG)_CHECKSUM := 626eddedee86059ccab593a226c8d98571018b46
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_WEBSITE  := http://tux4kids.alioth.debian.org/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/tuxmath/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sdl sdl_mixer sdl_image sdl_net sdl_pango sdl_ttf libpng librsvg libxml2 pthreads

define $(PKG)_UPDATE
    wget -q -O- 'http://alioth.debian.org/frs/?group_id=31080' | \
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
