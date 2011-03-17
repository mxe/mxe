# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# openal
PKG             := openal
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.13
$(PKG)_CHECKSUM := 0e2449375a12cee65a9cea354533dcaabf9d5068
$(PKG)_SUBDIR   := openal-soft-$($(PKG)_VERSION)
$(PKG)_FILE     := openal-soft-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://kcat.strangesoft.net/openal.html
$(PKG)_URL      := http://kcat.strangesoft.net/openal-releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc portaudio

define $(PKG)_UPDATE
    wget -q -O- 'http://kcat.strangesoft.net/openal-releases/?C=M;O=D' | \
    $(SED) -n 's,.*"openal-soft-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DLIBTYPE=STATIC
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-openal.exe' \
        `'$(TARGET)-pkg-config' openal --cflags --libs`
endef
