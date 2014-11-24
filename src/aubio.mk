# This file is part of MXE.
# See index.html for further information.

PKG             := aubio
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.4.1
$(PKG)_CHECKSUM := 338ec9f633e82c371a370b9727d6f0b86b0ba376
$(PKG)_SUBDIR   := aubio-$($(PKG)_VERSION)
$(PKG)_FILE     := aubio-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.aubio.org/pub/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc ffmpeg fftw libsamplerate libsndfile

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.aubio.org/download' | \
    $(SED) -n 's,.*aubio-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' &&                                  \
        AR='$(TARGET)-ar'                         \
        CC='$(TARGET)-gcc'                        \
        PKGCONFIG='$(TARGET)-pkg-config'          \
        ./waf configure build install             \
            -j '$(JOBS)'                          \
            --with-target-platform='win$(BITS)'   \
            --prefix='$(PREFIX)/$(TARGET)'        \
            --enable-fftw3f                       \
            $(if $(BUILD_STATIC),                 \
                --enable-static --disable-shared, \
                --disable-static --enable-shared)

    # It is not trivial to adjust the installation path for the DLL in the
    # waf-based build system. Adjust it here.
    $(if $(BUILD_SHARED),                         \
        mv '$(PREFIX)/$(TARGET)/lib/libaubio-4.dll' '$(PREFIX)/$(TARGET)/bin')

    '$(TARGET)-gcc'                               \
        -W -Wall -Werror -ansi -pedantic          \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-aubio.exe' \
        `'$(TARGET)-pkg-config' aubio --cflags --libs`
endef
