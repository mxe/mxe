# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := poppler
$(PKG)_WEBSITE  := https://poppler.freedesktop.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.51.0
$(PKG)_CHECKSUM := e997c9ad81a8372f2dd03a02b00692b8cc479c220340c8881edaca540f402c1f
$(PKG)_SUBDIR   := poppler-$($(PKG)_VERSION)
$(PKG)_FILE     := poppler-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://poppler.freedesktop.org/$($(PKG)_FILE)
$(PKG)_DEPS     := cc cairo curl freetype glib jpeg lcms libpng qtbase tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://poppler.freedesktop.org/' | \
    $(SED) -n 's,.*"poppler-\([0-9.]\+\)\.tar\.xz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # Note: Specifying LIBS explicitly is necessary for configure to properly
    #       pick up libtiff (otherwise linking a minimal test program fails not
    #       because libtiff is not found, but because some references are
    #       undefined)
    cd '$(1)' \
        && PATH='$(PREFIX)/$(TARGET)/$(if $(filter qtbase,$($(PKG)_DEPS)),qt5,qt)/bin:$(PATH)' \
        ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-silent-rules \
        --enable-xpdf-headers \
        $(if $(filter qtbase,$($(PKG)_DEPS)), \
          --enable-poppler-qt5 \
          --disable-poppler-qt4, \
          --disable-poppler-qt5 \
          --enable-poppler-qt4) \
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
        CXXFLAGS="-D_WIN32_WINNT=0x0500 -std=c++11" \
        LIBTIFF_LIBS="`'$(TARGET)-pkg-config' libtiff-4 --libs`"
    PATH='$(PREFIX)/$(TARGET)/$(if $(filter qtbase,$($(PKG)_DEPS)),qt5,qt)/bin:$(PATH)' \
        $(MAKE) -C '$(1)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT) HTML_DIR=
    $(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_CRUFT) HTML_DIR=

    # Test program
    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-poppler.exe' \
        `'$(TARGET)-pkg-config' poppler poppler-cpp --cflags --libs`
endef
