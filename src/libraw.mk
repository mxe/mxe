# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libraw
$(PKG)_WEBSITE  := https://libraw.org
$(PKG)_DESCR    := A library for reading RAW files obtained from digital photo cameras
$(PKG)_VERSION  := 0.19.5
$(PKG)_CHECKSUM := 9a2a40418e4fb0ab908f6d384ff6f9075f4431f8e3d79a0e44e5a6ea9e75abdc
$(PKG)_GH_CONF  := LibRaw/LibRaw/releases
$(PKG)_DEPS     := cc jasper jpeg lcms

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && autoreconf -fi
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)'/configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-jasper \
        --enable-jpeg \
        --enable-lcms \
        --disable-examples \
        CXXFLAGS='-std=gnu++11 $(if $(BUILD_SHARED),-DLIBRAW_BUILDLIB,-DLIBRAW_NODLL)' \
        LDFLAGS='-lws2_32'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' install
    # add missing entries to pkg-config file
    (echo ''; \
     echo 'Libs.private: -lws2_32 -ljasper'; \
     echo 'Cflags.private: -DLIBRAW_NODLL';) \
     >> '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    '$(TARGET)-g++' -Wall -Wextra -std=c++11 \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' libraw --cflags --libs`
endef
