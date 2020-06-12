# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := aubio
$(PKG)_WEBSITE  := https://www.aubio.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.4.2
$(PKG)_CHECKSUM := 1cc58e0fed2b9468305b198ad06b889f228b797a082c2ede716dc30fcb4f8f1f
$(PKG)_SUBDIR   := aubio-$($(PKG)_VERSION)
$(PKG)_FILE     := aubio-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://www.aubio.org/pub/$($(PKG)_FILE)
$(PKG)_DEPS     := cc ffmpeg fftw jack libsamplerate libsndfile $(BUILD)~waf

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.aubio.org/download' | \
    $(SED) -n 's,.*aubio-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(call PREPARE_PKG_SOURCE,waf,$(BUILD_DIR))
    rm -rf '$(1)/waf' '$(1)/waflib'
    cd '$(1)' &&                                  \
        AR='$(TARGET)-ar'                         \
        CC='$(TARGET)-gcc'                        \
        PKGCONFIG='$(TARGET)-pkg-config'          \
        $(PYTHON2)                                \
        '$(BUILD_DIR)/$(waf_SUBDIR)/waf'          \
            configure                             \
            -j '$(JOBS)'                          \
            --with-target-platform='win$(BITS)'   \
            --prefix='$(PREFIX)/$(TARGET)'        \
            --enable-fftw3f                       \
            --libdir='$(PREFIX)/$(TARGET)/lib'    \
            $(if $(BUILD_STATIC),                 \
                --enable-static --disable-shared --disable-jack, \
                --disable-static --enable-shared)

    # disable txt2man and doxygen
    $(SED) -i '/\(TXT2MAN\|DOXYGEN\)/d' '$(1)/build/c4che/_cache.py'

    cd '$(1)' && $(PYTHON2) '$(BUILD_DIR)/$(waf_SUBDIR)/waf' build install

    '$(TARGET)-gcc'                               \
        -W -Wall -Werror -ansi -pedantic          \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-aubio.exe' \
        `'$(TARGET)-pkg-config' aubio --cflags --libs`
endef
