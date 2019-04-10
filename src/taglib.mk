# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := taglib
$(PKG)_WEBSITE  := https://taglib.org/
$(PKG)_DESCR    := TagLib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6455671
$(PKG)_CHECKSUM := 11506839f52b8ae6da8f16409e73fa2733e9a2c2e2912e666dcfb57e20dc65f3
$(PKG)_GH_CONF  := taglib/taglib/branches/master
$(PKG)_DEPS     := cc zlib

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
