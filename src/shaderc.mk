# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := shaderc
$(PKG)_WEBSITE  := https://github.com/google/shaderc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 30af9f9
$(PKG)_CHECKSUM := b20f1a7ed6b9f732d636a12d32f584304404d6dc1b02b58a28979b86d1c74b2d
$(PKG)_GH_CONF  := google/shaderc/branches/master
$(PKG)_DEPS     := cc spirv-tools-src spirv-headers-src glslang-src

define $(PKG)_BUILD
    # set up the third-party sources
    $(call PREPARE_PKG_SOURCE,spirv-tools-src,$(SOURCE_DIR)/third_party)
    mv '$(SOURCE_DIR)/third_party/$(spirv-tools-src_SUBDIR)' '$(SOURCE_DIR)/third_party/spirv-tools'
    $(call PREPARE_PKG_SOURCE,spirv-headers-src,$(SOURCE_DIR)/third_party)
    mv '$(SOURCE_DIR)/third_party/$(spirv-headers-src_SUBDIR)' '$(SOURCE_DIR)/third_party/spirv-headers'
    $(call PREPARE_PKG_SOURCE,glslang-src,$(SOURCE_DIR)/third_party)
    mv '$(SOURCE_DIR)/third_party/$(glslang-src_SUBDIR)' '$(SOURCE_DIR)/third_party/glslang'

    # build and install the library
    echo '"$($(PKG)_VERSION)"' > '$(SOURCE_DIR)'/glslc/src/build-version.inc
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DSHADERC_SKIP_TESTS=ON \
        -DENABLE_GLSLANG_BINARIES=OFF \
        -DSKIP_GLSLANG_INSTALL=ON \
        -DSKIP_SPIRV_TOOLS_INSTALL=ON \
        -DSPIRV_SKIP_EXECUTABLES=ON \
        -DSPIRV_BUILD_COMPRESSION=ON \
        -DSPIRV_WERROR=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
