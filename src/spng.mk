# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

PKG             := spng
$(PKG)_WEBSITE  := https://libspng.org
$(PKG)_DESCR    := Simple PNG library
$(PKG)_VERSION  := 0.7.4
$(PKG)_CHECKSUM := 47ec02be6c0a6323044600a9221b049f63e1953faf816903e7383d4dc4234487
$(PKG)_GH_CONF  := randy408/libspng/tags,v
$(PKG)_DEPS     := cc zlib

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DCMAKE_INSTALL_PREFIX='$(PREFIX)/$(TARGET)' \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SHARED_LIBS=OFF \
        -DSPNG_BUILD_TESTS=OFF \
		-DSPNG_SHARED=OFF \
		-DSPNG_STATIC=ON \
		-DBUILD_EXAMPLES=OFF \
		-DZLIB_ROOT='$(PREFIX)/$(TARGET)'

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-g++' \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `$(TARGET)-pkg-config lib$(PKG)_static --cflags --libs`

endef
