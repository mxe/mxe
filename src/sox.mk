# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# sox
PKG             := sox
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 14.3.2
$(PKG)_CHECKSUM := ad462114ff47b094078f18148bc9e29e31b42b92
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://sox.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libmad lame vorbis ffmpeg flac

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/sox/files/sox/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) -i 's,cross_compiling=no,cross_compiling=yes,' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install

    '$(1)/libtool' --tag=CC --mode=link '$(TARGET)-gcc' -all-static \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-sox.exe' \
        -lsox
endef
