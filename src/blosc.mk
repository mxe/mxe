# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := blosc
$(PKG)_WEBSITE  := https://github.com/Blosc/c-blosc
$(PKG)_DESCR    := The Blosc high-performance blocking, shuffling and compression library
$(PKG)_VERSION  := 1.21.6
$(PKG)_FILE     := c-blosc-$($(PKG)_VERSION).tar.gz
$(PKG)_CHECKSUM := 9fcd60301aae28f97f1301b735f966cc19e7c49b6b4321b839b4579a0c156f38
$(PKG)_SUBDIR   := c-blosc-$($(PKG)_VERSION)
$(PKG)_URL      := https://github.com/Blosc/c-blosc/archive/refs/tags/v$($(PKG)_VERSION).tar.gz
$(PKG)_TARGETS  := $(BUILD)
$(PKG)_DEPS     := cmake

define $(PKG)_BUILD
        cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
                -DBUILD_SHARED_LIBS=OFF \
                -DCMAKE_INSTALL_PREFIX='$(PREFIX)/$(TARGET)'
        $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' || $(MAKE) -C '$(BUILD_DIR)' -j 1
        $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
