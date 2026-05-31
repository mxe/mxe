# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := aubio
$(PKG)_WEBSITE  := https://www.aubio.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.4.9
$(PKG)_CHECKSUM := d48282ae4dab83b3dc94c16cf011bcb63835c1c02b515490e1883049c3d1f3da
$(PKG)_SUBDIR   := aubio-$($(PKG)_VERSION)
$(PKG)_FILE     := aubio-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://www.aubio.org/pub/$($(PKG)_FILE)
$(PKG)_DEPS     := cc fftw jack libsamplerate libsndfile

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.aubio.org/download' | \
    $(SED) -n 's,.*aubio-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # Fix Python 3.13 compatibility (imp module is removed) in bundled waf
    $(SED) -i 's/import os,re,imp,sys/import os,re,sys,types/g' '$(1)/waflib/Context.py'
    $(SED) -i 's/import os, re, imp, sys/import os, re, sys, types/g' '$(1)/waflib/Context.py'
    $(SED) -i 's/imp\.new_module/types.ModuleType/g' '$(1)/waflib/Context.py'
    # Fix Python 3.11+ compatibility (rU mode is removed)
    $(SED) -i "s/'rU'/'r'/g" '$(1)/waflib/Context.py'
    $(SED) -i "s/'rU'/'r'/g" '$(1)/waflib/ConfigSet.py'
    cd '$(1)' &&                                  \
        AR='$(TARGET)-ar'                         \
        CC='$(TARGET)-gcc'                        \
        PKGCONFIG='$(TARGET)-pkg-config'          \
        $(PYTHON)                                 \
        ./waf                                     \
            configure                             \
            -j '$(JOBS)'                          \
            --with-target-platform='win$(BITS)'   \
            --prefix='$(PREFIX)/$(TARGET)'        \
            --enable-fftw3f                       \
            --disable-tests                       \
            --disable-examples                    \
            --disable-avcodec                     \
            --disable-docs                        \
            --libdir='$(PREFIX)/$(TARGET)/lib'    \
            $(if $(BUILD_STATIC),                 \
                --enable-static --disable-shared --disable-jack, \
                --disable-static --enable-shared)

    cd '$(1)' && $(PYTHON) ./waf build install -v --disable-tests --disable-examples --disable-docs

    $(if $(BUILD_SHARED), \
        mv -v '$(PREFIX)/$(TARGET)/lib/libaubio-'*.dll '$(PREFIX)/$(TARGET)/bin/')

    '$(TARGET)-gcc'                               \
        -W -Wall -Werror -ansi -pedantic          \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-aubio.exe' \
        `'$(TARGET)-pkg-config' aubio --cflags --libs`
endef
