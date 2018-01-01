# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cmark
$(PKG)_WEBSITE  := https://github.com/commonmark/cmark
$(PKG)_DESCR    := CommonMark parsing and rendering library and program in C
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.28.3
$(PKG)_CHECKSUM := acc98685d3c1b515ff787ac7c994188dadaf28a2d700c10c1221da4199bae1fc
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/commonmark/cmark/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, commonmark/cmark)
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && \
        '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DCMARK_STATIC=$(CMAKE_STATIC_BOOL) \
        -DCMARK_SHARED=$(CMAKE_SHARED_BOOL) \
        -DCMARK_TESTS=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1 || $(MAKE) -C '$(BUILD_DIR)' -j 1 VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1
endef
