# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# t4k_common
PKG             := t4k_common
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.1
$(PKG)_CHECKSUM := 626eddedee86059ccab593a226c8d98571018b46
$(PKG)_SUBDIR   := t4k_common-$($(PKG)_VERSION)
$(PKG)_FILE     := t4k_common-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://tux4kids.alioth.debian.org/

$(PKG)_URL      := http://sourceforge.net/projects/tuxmath/files/t4k_common/$($(PKG)_FILE)/download
$(PKG)_DEPS     := gcc sdl sdl_mixer sdl_image sdl_net sdl_pango sdl_ttf libpng librsvg libxml2 pthreads

# FIXME find out how to update package
#define $(PKG)_UPDATE
#    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/sdlpango/files/SDL_Pango/) | \
#    $(SED) -n 's,.*SDL_Pango-\([0-9][^>]*\)\.tar.*,\1,p' | \
#    tail -1
#endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
