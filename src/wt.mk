# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := wt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.3.6
$(PKG)_CHECKSUM := 8f82576076deb1d72cfb8ff42cf7ffb3553a45da32123b2a3cf36e66040678ab
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/kdeforche/wt/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc boost graphicsmagick libharu openssl pango postgresql qt sqlite

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_ALL_TAGS, kdeforche/wt) \
    | grep -v 'rc' \
    | $(SORT) -V \
    | tail -1
endef

define $(PKG)_BUILD
    # build wt libraries
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
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
        -DENABLE_QT4=ON \
        -DWT_CMAKE_FINDER_INSTALL_DIR='/lib/wt' \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        '$(1)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' VERBOSE=1 || $(MAKE) -C '$(1).build' -j 1 VERBOSE=1
    $(MAKE) -C '$(1).build' -j 1 install VERBOSE=1
endef
