# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libcomm14cux
$(PKG)_WEBSITE  := https://github.com/colinbourassa/libcomm14cux/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.3
$(PKG)_CHECKSUM := 5c7d165ea76d036631489b6ca36431d267f08ebf1749e7c959a8787f355569a0
$(PKG)_GH_CONF  := colinbourassa/libcomm14cux/releases/latest
$(PKG)_URL      := https://github.com/colinbourassa/libcomm14cux/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
