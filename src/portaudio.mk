# This file is part of MXE.
# See index.html for further information.

PKG             := portaudio
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 3841453bb7be672a15b6b632ade6f225eb0a4efc
$(PKG)_SUBDIR   := portaudio
$(PKG)_FILE     := pa_stable_v$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.portaudio.com/archives/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.portaudio.com/download.html' | \
    $(SED) -n 's,.*pa_stable_v\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoconf
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        $(LINK_STYLE) \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-host_os=mingw \
        --with-winapi=directx \
        --with-dxdir=$(PREFIX)/$(TARGET)
    $(MAKE) -C '$(1)' -j '$(JOBS)' SHARED_FLAGS= TESTS=
    $(MAKE) -C '$(1)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-portaudio.exe' \
        `'$(TARGET)-pkg-config' portaudio-2.0 --cflags --libs`
endef

$(PKG)_BUILD_i686-static-mingw32   = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-static-mingw32 = $($(PKG)_BUILD)
