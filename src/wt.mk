# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# Wt
PKG             := wt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.0
$(PKG)_CHECKSUM := 38cf20980f16b0970c42ace45fd62edb28b6358b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://witty.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/witty/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc boost openssl libharu graphicsmagick pango postgresql sqlite qt

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/witty/files/witty/' | \
    $(SED) -n 's,.*wt-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    # build wt libraries
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
        -DCONFIGDIR='$(PREFIX)/$(TARGET)/etc/wt' \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_TESTS=OFF \
        -DSHARED_LIBS=OFF \
        -DBOOST_DYNAMIC=OFF \
        -DBOOST_PREFIX='$(PREFIX)/$(TARGET)' \
        -DBOOST_COMPILER=_win32 \
        -DSSL_PREFIX='$(PREFIX)/$(TARGET)' \
        -DOPENSSL_LIBS="`'$(TARGET)-pkg-config' --libs-only-l openssl`" \
        -DGM_PREFIX='$(PREFIX)/$(TARGET)' \
        -DGM_LIBS="`'$(TARGET)-pkg-config' --libs-only-l GraphicsMagick++`" \
        -DPANGO_FT2_LIBS="`'$(TARGET)-pkg-config' --libs-only-l pangoft2`" \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_BUILD_TYPE:STRING="Release" \
        '$(1)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' install VERBOSE=1
endef
