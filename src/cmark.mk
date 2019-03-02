# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cmark
$(PKG)_WEBSITE  := https://github.com/commonmark/cmark
$(PKG)_DESCR    := CommonMark parsing and rendering library and program in C
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.28.3
$(PKG)_CHECKSUM := acc98685d3c1b515ff787ac7c994188dadaf28a2d700c10c1221da4199bae1fc
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
