# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libcomm14cux
$(PKG)_WEBSITE  := https://github.com/colinbourassa/libcomm14cux/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.1
$(PKG)_CHECKSUM := 4b3d0969e2226a0f3c1250c609858e487631507ed62bf6732ce82f13f0d9fcc9
$(PKG)_GH_CONF  := colinbourassa/libcomm14cux/releases/latest
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
