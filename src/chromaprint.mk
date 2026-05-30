# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := chromaprint
$(PKG)_WEBSITE  := https://acoustid.org/chromaprint
$(PKG)_DESCR    := Chromaprint
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6.0
$(PKG)_CHECKSUM := 65bfce4a35b2e673dbcda917b6aa577e2f145cf805243d19e6a50fea2a520c2a
$(PKG)_GH_CONF  := acoustid/chromaprint/tags, v
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc ffmpeg

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' -DBUILD_TESTS=OFF '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
