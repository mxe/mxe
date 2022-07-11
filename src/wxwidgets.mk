# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := wxwidgets
$(PKG)_WEBSITE  := https://www.wxwidgets.org/
$(PKG)_DESCR    := wxWidgets
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.7
$(PKG)_CHECKSUM := 3d666e47d86192f085c84089b850c90db7a73a5d26b684b617298d89dce84f19
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
