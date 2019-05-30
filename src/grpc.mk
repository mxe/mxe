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
      -DCMAKE_CXX_FLAGS="-D_WIN32_WINNT=0x0600" \
      $(PKG_CMAKE_OPTS)

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # create pkg-config files
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: gRPC'; \
     echo 'Description: high performance general RPC framework'; \
     echo 'Version: $(grpc_VERSION)'; \
     echo 'Libs: -lgrpc'; \
     echo 'Libs.private: -lz -lcares -lssl -lcrypto -lgpr -lws2_32 -laddress_sorting';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/grpc.pc'

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echp 'Name: gRPC++'; \
     echo 'Description: C++ wrapper for gRPC'; \
     echo 'Version: $(grpc_VERSION)'; \
     echo 'Requires.private: grpc'; \
     echo 'Libs: -lgrpc++'; \
     echo 'Libs.private: -lprotobuf';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/grpc++.pc'

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: gRPC unsecure'; \
     echo 'Description: high performance general RPC framework without SSL'; \
     echo 'Version: $(grpc_VERSION)'; \
     echo 'Libs: -lgrpc'; \
     echo 'Libs.private: -lz -lcares -lgpr -lws2_32 -laddress_sorting';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/grpc_unsecure.pc'

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: gRPC++ unsecure'; \
     echo 'Description: C++ wrapper for gRPC without SSL'; \
     echo 'Version: $(grpc_VERSION)'; \
     echo 'Requires.private: grpc_unsecure'; \
     echo 'Libs: -lgrpc++'; \
     echo 'Libs.private: -lprotobuf';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/grpc++_unsecure.pc'

     '$(TARGET)-g++' \
            -W -Wall -Werror -ansi -pedantic -std=c++14 \
            '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-grpc.exe' \
            `'$(TARGET)-pkg-config' grpc grpc++ --cflags --libs`

endef

define $(PKG)_BUILD_$(BUILD)
    cd '$(BUILD_DIR)' && PKG_CONFIG_PATH='$(PREFIX)/$(TARGET)/lib/pkgconfig' $(MAKE) \
        CXX='$(BUILD_CXX)' \
        CC='$(BUILD_CC)' \
        prefix='$(PREFIX)/$(TARGET)' \
        -C '$(SOURCE_DIR)' \
				$(if $(BUILD_STATIC),install-static_cxx install-static_c) \
				$(if $(BUILD_SHARED),install-shared_cxx install-shared_c) \
				install-headers_c install-headers_cxx install-plugins
endef
