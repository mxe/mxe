# This file is part of MXE.
# See index.html for further information.

PKG             := openal
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.16.0
$(PKG)_CHECKSUM := f70892fc075ae726320478c0179f7011fea0d157
$(PKG)_SUBDIR   := openal-soft-$($(PKG)_VERSION)
$(PKG)_FILE     := openal-soft-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://kcat.strangesoft.net/openal-releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc portaudio sdl_sound sdl2 ffmpeg 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://kcat.strangesoft.net/openal-releases/?C=M;O=D' | \
    $(SED) -n 's,.*"openal-soft-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

# NB disabled building of ALSOFT_EXAMPLES executables, because it
# requires linking to both SDL_sound and SDL2, but these are
# incompatible libraries.

define $(PKG)_BUILD
    # enable common library, which is mysteriously disabled
    sed -i -e 's/#ADD_LIBRARY(common/ADD_LIBRARY(common/' $(1)/CMakeLists.txt
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DLIBTYPE=$(if $(BUILD_SHARED),SHARED,STATIC) \
        -DEXAMPLES=FALSE \
        -DALSOFT_UTILS=FALSE \
        -DALSOFT_EXAMPLES=FALSE \
        -DEXTRA_LIBS="`$(TARGET)-pkg-config --libs SDL_sound libavformat sdl2 ` "
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-openal.exe' \
        `'$(TARGET)-pkg-config' openal --cflags --libs`
endef
