# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

PKG             := openjph
$(PKG)_WEBSITE  := https://openjph.org/
$(PKG)_DESCR    := OpenJPH - High Throughput JPEG 2000 (JPH / HTJ2K) library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.26.3
$(PKG)_CHECKSUM := 29de006da7f1e8cf0cd7c3ec424cf29103e465052c00b5a5f0ccb7e1f917bb3f
$(PKG)_GH_CONF  := aous72/OpenJPH/tags
$(PKG)_DEPS     := cc zlib

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DCMAKE_INSTALL_PREFIX='$(PREFIX)/$(TARGET)' \
        -DBUILD_SHARED_LIBS=OFF \
        -DOJPH_BUILD_TESTS=OFF \
        -DOJPH_BUILD_EXECUTABLES=ON \
        -DOJPH_DISABLE_SIMD=ON \
        -DOJPH_ENABLE_TIFF_SUPPORT=OFF \
        -DCMAKE_BUILD_TYPE=Release

    $(MAKE) -C "$(BUILD_DIR)" -j "$(JOBS)"
    $(MAKE) -C "$(BUILD_DIR)" -j 1 install

    '$(TARGET)-g++' \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-openjph.exe' \
        `'$(TARGET)-pkg-config' openjph --cflags --libs`
endef
