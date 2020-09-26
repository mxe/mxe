# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ilmbase
$(PKG)_WEBSITE  := https://www.openexr.com/
$(PKG)_DESCR    := IlmBase
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5.1
$(PKG)_CHECKSUM := 11f806bf256453e39fc33bd1cf1fa576a54f144cedcdd3e6935a177e5a89d02e
$(PKG)_GH_CONF  := AcademySoftwareFoundation/openexr/releases,v
$(PKG)_FILE     := openexr-v$($(PKG)_VERSION).tar.gz
$(PKG)_SUBDIR   := openexr-$($(PKG)_VERSION)
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake \
        -DOPENEXR_CXX_STANDARD=11 \
        -DBUILD_TESTING=OFF \
        -DILMBASE_INSTALL_PKG_CONFIG=ON \
        "$(SOURCE_DIR)"/IlmBase
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
