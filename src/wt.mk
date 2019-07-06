# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := wt
$(PKG)_WEBSITE  := https://www.webtoolkit.eu/
$(PKG)_DESCR    := Wt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.0.5
$(PKG)_CHECKSUM := 0863f6e7118512d4976cae42e6849a6569e11f93601f0f276e793f26e22ed9e9
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
