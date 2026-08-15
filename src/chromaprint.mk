# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := chromaprint
$(PKG)_WEBSITE  := https://acoustid.org/chromaprint
$(PKG)_DESCR    := Chromaprint
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6.1
$(PKG)_CHECKSUM := 7065ec9db48ac1fa929ec6c42afcd966605b1bfe48b6d5e64c25378a05f4fb02
$(PKG)_GH_CONF  := acoustid/chromaprint/tags, v
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc ffmpeg

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' -DBUILD_TESTS=OFF '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
