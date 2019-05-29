# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := grpc
$(PKG)_WEBSITE  := https://github.com/grpc/grpc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.19.1
$(PKG)_CHECKSUM := f869c648090e8bddaa1260a271b1089caccbe735bf47ac9cd7d44d35a02fb129
$(PKG)_GH_CONF  := grpc/grpc/tags,v
$(PKG)_DEPS     := cc protobuf zlib c-ares $(BUILD)~$(PKG)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS_$(BUILD) := protobuf libtool

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
      -DgRPC_ZLIB_PROVIDER="package" \
      -DgRPC_CARES_PROVIDER="package" \
      -DgRPC_PROTOBUF_PROVIDER="package" \
      -DgRPC_SSL_PROVIDER="package" \
      -DgRPC_GFLAGS_PROVIDER="modules" \
      -DgRPC_BENCHMARK_PROVIDER="modules" \
      $(PKG_CMAKE_OPTS)

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

endef

define $(PKG)_BUILD_$(BUILD)
    cd '$(BUILD_DIR)' && PKG_CONFIG_PATH='$(PREFIX)/$(TARGET)/lib/pkgconfig' $(MAKE) \
        CXX='$(BUILD_CXX)' \
        CC='$(BUILD_CC)' \
        prefix='$(PREFIX)/$(TARGET)' \
        -C '$(SOURCE_DIR)' install-static_cxx install-static_c install-plugins
endef
