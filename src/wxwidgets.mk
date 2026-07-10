# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := wxwidgets
$(PKG)_WEBSITE  := https://www.wxwidgets.org/
$(PKG)_DESCR    := wxWidgets
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.3.3
$(PKG)_CHECKSUM := 81b09d6dd9f1ed9301f8c55a968a488d0491f264dc2bab19a7e407ac67009482
$(PKG)_GH_CONF  := wxWidgets/wxWidgets/releases/latest,v,,,,.tar.bz2
$(PKG)_DEPS     := cc expat jpeg libiconv libpng sdl tiff zlib

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --enable-option-checking \
        --enable-gui \
        --enable-unicode \
        --disable-stl \
        --disable-gtktest \
        --enable-threads \
        --enable-backtrace \
        --disable-universal \
        --with-themes=all \
        --with-msw \
        --with-opengl \
        --with-libpng=sys \
        --with-libjpeg=sys \
        --with-libtiff=sys \
        --with-regex=yes \
        --with-zlib=sys \
        --with-expat=sys \
        --with-sdl \
        --without-gtk \
        --without-macosx-sdk \
        --without-libxpm \
        --without-libmspack \
        --without-gnomevfs \
        --without-dmalloc \
        $(PKG_CONFIGURE_OPTS)

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT) __install_wxrc___depname=

    $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/bin/wx-config' \
                     '$(PREFIX)/bin/$(TARGET)-wx-config'

    # build test program
    '$(TARGET)-g++' \
        -W -Wall -pedantic -std=gnu++0x \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-wxwidgets.exe' \
        `'$(TARGET)-wx-config' --cflags --libs`
endef
