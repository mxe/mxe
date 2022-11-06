# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libraw
$(PKG)_WEBSITE  := https://libraw.org
$(PKG)_DESCR    := A library for reading RAW files obtained from digital photo cameras
$(PKG)_VERSION  := 0.20.2
$(PKG)_CHECKSUM := 02df7d403b34602b769bb38e5bf7d4258e075eeefbe980b6832e6e1491989d60
$(PKG)_GH_CONF  := LibRaw/LibRaw/tags
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
    # add missing entries to pkg-config files
    (echo ''; \
     echo 'Libs.private: -lws2_32 -ljasper'; \
     echo 'Cflags.private: -DLIBRAW_NODLL';) \
     | tee -a '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc' \
              '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG)_r.pc'

    '$(TARGET)-g++' -Wall -Wextra -std=c++11 \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' libraw --cflags --libs`
endef
