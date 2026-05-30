# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := abseil-cpp
$(PKG)_WEBSITE  := https://abseil.io/
$(PKG)_DESCR    := Abseil C++ Common Libraries
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 20260107.1
$(PKG)_CHECKSUM := 4314e2a7cbac89cac25a2f2322870f343d81579756ceff7f431803c2c9090195
$(PKG)_GH_CONF  := abseil/abseil-cpp/tags
$(PKG)_DEPS     := cc

# Abseil is needed by protobuf. Protobuf cross-compilation requires native protoc,
# which in turn requires native abseil. We build abseil natively first.
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DCMAKE_INSTALL_PREFIX='$(PREFIX)/$(TARGET)' \
        -DABSL_PROPAGATE_CXX_STD=ON \
        -DABSL_ENABLE_INSTALL=ON \
        -DBUILD_TESTING=OFF \
        -DABSL_BUILD_TESTING=OFF \
        -DCMAKE_CXX_STANDARD=17
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
