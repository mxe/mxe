# This file is part of MXE.
# See index.html for further information.

PKG             := smpeg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.4.5+cvs20030824
$(PKG)_CHECKSUM := 1276ea797dd9fde8a12dd3f33f180153922544c28ca9fc7b477c018876be1916
$(PKG)_SUBDIR   := smpeg-$($(PKG)_VERSION).orig
$(PKG)_FILE     := smpeg_$($(PKG)_VERSION).orig.tar.gz
$(PKG)_URL      := http://ftp.debian.org/debian/pool/main/s/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sdl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://packages.debian.org/unstable/source/smpeg' | \
    $(SED) -n 's,.*smpeg_\([0-9][^>]*\)\.orig\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,\(-lsmpeg\),\1 -lstdc++,' '$(1)/smpeg-config.in'
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

    '$(TARGET)-gcc' \
        -W -Wall -Werror -std=c99 -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-smpeg.exe' \
        `'$(PREFIX)/$(TARGET)/bin/smpeg-config' --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
