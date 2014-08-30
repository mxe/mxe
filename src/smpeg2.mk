# This file is part of MXE.
# See index.html for further information.

PKG             := smpeg2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.0
$(PKG)_CHECKSUM := d0455466f61a8e55f83f4d7fd82f1c305bce6832
$(PKG)_SUBDIR   := smpeg2-$($(PKG)_VERSION)
$(PKG)_FILE     := smpeg2-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.libsdl.org/projects/smpeg/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sdl2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://packages.debian.org/unstable/source/smpeg' | \
    $(SED) -n 's,.*smpeg2_\([0-9][^>]*\)\.orig\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,\(-lsmpeg2\),\1 -lstdc++,' '$(1)/smpeg2-config.in'
    cd '$(1)' && ./configure \
        AR='$(TARGET)-ar' \
        NM='$(TARGET)-nm' \
        --host='$(TARGET)' \
        --disable-shared \
        --disable-debug \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --disable-gtk-player \
        --disable-opengl-player \
        CFLAGS='-ffriend-injection'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

#    '$(TARGET)-gcc' \
#        -W -Wall -Werror -std=c99 -pedantic \
#        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-smpeg2.exe' \
#        `'$(PREFIX)/$(TARGET)/bin/smpeg2-config' --cflags --libs`
endef

$(PKG)_BUILD_i686-pc-mingw32 =

$(PKG)_BUILD_SHARED =
