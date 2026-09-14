# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := abseil-cpp
$(PKG)_WEBSITE  := https://abseil.io/
$(PKG)_DESCR    := Abseil C++ common libraries
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 20240722.1
$(PKG)_CHECKSUM := 40cee67604060a7c8794d931538cb55f4d444073e556980c88b6c49bb9b19bb7
$(PKG)_GH_CONF  := abseil/abseil-cpp/releases/latest
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_TESTING=OFF \
        -DABSL_ENABLE_INSTALL=ON \
        -DABSL_PROPAGATE_CXX_STD=ON \
        -DCMAKE_CXX_STANDARD=17
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
