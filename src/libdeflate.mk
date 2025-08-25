# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libdeflate
$(PKG)_WEBSITE  := https://github.com/ebiggers/libdeflate
$(PKG)_DESCR    := libdeflate
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.24
$(PKG)_CHECKSUM := ad8d3723d0065c4723ab738be9723f2ff1cb0f1571e8bfcf0301ff9661f475e8
$(PKG)_GH_CONF  := ebiggers/libdeflate/releases,v
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_URL      := https://github.com/ebiggers/libdeflate/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
            -DLIBDEFLATE_BUILD_SHARED_LIB=$(CMAKE_SHARED_BOOL) \
            -DCMAKE_INSTALL_LIBDIR='$(PREFIX)/$(TARGET)/lib' \
            -DLIBDEFLATE_BUILD_GZIP=OFF \
            -DCMAKE_BUILD_TYPE="Release" \
         '$(1)' 
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1
endef
