# This file is part of MXE.
# See index.html for further information.

PKG             := poppler
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.30.0
$(PKG)_CHECKSUM := b616ee869d0b1f8a7a2c71cf346f55c1bff624cce4badebe17f506ec8ce7ddf5
$(PKG)_SUBDIR   := poppler-$($(PKG)_VERSION)
$(PKG)_FILE     := poppler-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://poppler.freedesktop.org/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc cairo curl freetype glib jpeg lcms libpng qt tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://poppler.freedesktop.org/' | \
    $(SED) -n 's,.*"poppler-\([0-9.]\+\)\.tar\.xz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # Note: Specifying LIBS explicitly is necessary for configure to properly
    #       pick up libtiff (otherwise linking a minimal test program fails not
    #       because libtiff is not found, but because some references are
    #       undefined)
    cd '$(1)' \
        && PATH='$(PREFIX)/$(TARGET)/qt/bin:$(PATH)' \
        ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-silent-rules \
        --disable-shared \
        --enable-static \
        --enable-xpdf-headers \
        --enable-poppler-qt4 \
        --enable-zlib \
        --enable-cms=lcms2 \
        --enable-libcurl \
        --enable-libtiff \
        --enable-libjpeg \
        --enable-libpng \
        --enable-poppler-glib \
        --enable-poppler-cpp \
        --enable-cairo-output \
        --enable-splash-output \
        --enable-compile-warnings=yes \
        --enable-introspection=auto \
        --disable-libopenjpeg \
        --disable-gtk-test \
        --disable-utils \
        --disable-gtk-doc \
        --disable-gtk-doc-html \
        --disable-gtk-doc-pdf \
        --with-font-configuration=win32 \
        PKG_CONFIG_PATH_$(subst .,_,$(subst -,_,$(TARGET)))='$(PREFIX)/$(TARGET)/qt/lib/pkgconfig' \
        CXXFLAGS=-D_WIN32_WINNT=0x0500 \
        LIBTIFF_LIBS="`'$(TARGET)-pkg-config' libtiff-4 --libs`"
    PATH='$(PREFIX)/$(TARGET)/qt/bin:$(PATH)' \
        $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    # Test program
    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).cxx' -o '$(PREFIX)/$(TARGET)/bin/test-poppler.exe' \
        `'$(TARGET)-pkg-config' poppler poppler-cpp --cflags --libs`
endef

$(PKG)_BUILD_SHARED =

