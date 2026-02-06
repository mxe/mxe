# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := wt
$(PKG)_WEBSITE  := https://www.webtoolkit.eu/
$(PKG)_DESCR    := Wt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.12.2
$(PKG)_CHECKSUM := e0aaaaec05b243df6ebb93c4d648a9607156df3b049db723db3487bb80cab06a
$(PKG)_GH_CONF  := emweb/wt/tags
$(PKG)_DEPS     := cc boost graphicsmagick libharu openssl pango postgresql sqlite

define $(PKG)_BUILD
    # build wt libraries
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DCONFIGDIR='$(PREFIX)/$(TARGET)/etc/wt' \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_TESTS=OFF \
        -DSHARED_LIBS=$(if $(BUILD_STATIC),OFF,ON) \
        -DBOOST_DYNAMIC=$(if $(BUILD_STATIC),OFF,ON) \
        -DBOOST_PREFIX='$(PREFIX)/$(TARGET)' \
        -DBOOST_COMPILER=_win32 \
        -DSSL_PREFIX='$(PREFIX)/$(TARGET)' \
        -DOPENSSL_LIBS="`'$(TARGET)-pkg-config' --libs-only-l openssl`" \
        -DGM_PREFIX='$(PREFIX)/$(TARGET)' \
        -DGM_LIBS="`'$(TARGET)-pkg-config' --libs-only-l GraphicsMagick++`" \
        -DPANGO_FT2_LIBS="`'$(TARGET)-pkg-config' --libs-only-l pangoft2`" \
        -DWT_CMAKE_FINDER_INSTALL_DIR='/lib/wt'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1 || $(MAKE) -C '$(BUILD_DIR)' -j 1 VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1
endef
