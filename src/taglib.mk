# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := taglib
$(PKG)_WEBSITE  := https://taglib.org/
$(PKG)_DESCR    := TagLib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3
$(PKG)_CHECKSUM := 7349f6fd942418bc7009ebe743eb7c9d055f02921ec56fa436ec25007c47fd38
$(PKG)_GH_CONF  := taglib/taglib/releases, v
$(PKG)_DEPS     := cc zlib

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
