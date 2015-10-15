# This file is part of MXE.
# See index.html for further information.

PKG             := aubio
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.4.2
$(PKG)_CHECKSUM := 1cc58e0fed2b9468305b198ad06b889f228b797a082c2ede716dc30fcb4f8f1f
$(PKG)_SUBDIR   := aubio-$($(PKG)_VERSION)
$(PKG)_FILE     := aubio-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.aubio.org/pub/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc ffmpeg fftw jack libsamplerate libsndfile

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

    # It is not trivial to adjust the installation in waf-based builds
    $(if $(BUILD_STATIC),                         \
        $(INSTALL) -m644 '$(1)/build/src/libaubio.a' '$(PREFIX)/$(TARGET)/lib')

    '$(TARGET)-gcc'                               \
        -W -Wall -Werror -ansi -pedantic          \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-aubio.exe' \
        `'$(TARGET)-pkg-config' aubio --cflags --libs`
endef
