# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := protobuf
$(PKG)_WEBSITE  := https://github.com/google/protobuf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 35.0
$(PKG)_CHECKSUM := e127ea69dd7be4e88abdd95845fb6c30d25d96971d95827e92b70e2e910d46a1
$(PKG)_GH_CONF  := google/protobuf/tags,v
$(PKG)_DEPS     := cc abseil-cpp zlib $(BUILD)~$(PKG)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS_$(BUILD) := abseil-cpp

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DCMAKE_INSTALL_PREFIX='$(PREFIX)/$(TARGET)' \
        -Dprotobuf_BUILD_TESTS=OFF \
        -Dprotobuf_BUILD_EXAMPLES=OFF \
        -Dprotobuf_BUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -Dprotobuf_ABSEIL_PROVIDER=package \
        -Dprotobuf_WITH_ZLIB=$(if $(BUILD_CROSS),ON,OFF) \
        -Dprotobuf_BUILD_PROTOC_BINARIES=$(if $(BUILD_CROSS),OFF,ON) \
        $(if $(BUILD_CROSS),-Dprotobuf_PROTOC_EXE='$(PREFIX)/$(BUILD)/bin/protoc')
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    $(if $(BUILD_CROSS),
        '$(TARGET)-g++' \
            -W -Wall -Werror -ansi -pedantic -std=c++17 \
            '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-protobuf.exe' \
            `'$(TARGET)-pkg-config' protobuf --cflags --libs`
    )
endef
