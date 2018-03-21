# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := vc
$(PKG)_WEBSITE  := https://github.com/VcDevel/Vc
$(PKG)_DESCR    := SIMD Vector Classes for C++
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.3
$(PKG)_CHECKSUM := 08c629d2e14bfb8e4f1a10f09535e4a3c755292503c971ab46637d2986bdb4fe
$(PKG)_GH_CONF  := VcDevel/Vc/releases/latest
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DCMAKE_SYSTEM_PROCESSOR=x86 \
        -DBUILD_TESTING=OFF \
        -DBUILD_EXAMPLES=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $($(PKG)_DESCR)'; \
     echo 'Requires:'; \
     echo 'Libs: -lVc'; \
     echo 'Cflags.private:';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    # compile test
    '$(TARGET)-g++' \
        -W -Wall -Werror -std=c++14\
        '$(SOURCE_DIR)/examples/cpuid/main.cpp' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef

# https://github.com/VcDevel/Vc/issues/195
$(PKG)_BUILD_SHARED =
