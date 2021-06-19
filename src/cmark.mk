# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cmark
$(PKG)_WEBSITE  := https://github.com/commonmark/cmark
$(PKG)_DESCR    := CommonMark parsing and rendering library and program in C
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.29.0
$(PKG)_CHECKSUM := 2558ace3cbeff85610de3bda32858f722b359acdadf0c4691851865bb84924a6
$(PKG)_GH_CONF  := commonmark/cmark/releases
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && \
        '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DCMARK_STATIC=$(CMAKE_STATIC_BOOL) \
        -DCMARK_SHARED=$(CMAKE_SHARED_BOOL) \
        -DCMARK_TESTS=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1 || $(MAKE) -C '$(BUILD_DIR)' -j 1 VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1
endef
