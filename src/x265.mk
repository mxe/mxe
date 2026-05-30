# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := x265
$(PKG)_WEBSITE  := http://x265.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.2
$(PKG)_CHECKSUM := 40b1ea0453e0309f0eba934e0ddf533f8f6295966679e8894e8f1c1c8d5e1210
$(PKG)_SUBDIR   := x265_$($(PKG)_VERSION)
$(PKG)_FILE     := x265_$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://bitbucket.org/multicoreware/x265_git/downloads/$($(PKG)_FILE)
$(PKG)_DEPS     := cc $(BUILD)~nasm

define $(PKG)_UPDATE
    git ls-remote --tags https://bitbucket.org/multicoreware/x265_git.git | \
    $(SED) -n 's,.*refs/tags/\([0-9][^{]*\).*,\1,p' | \
    grep -v '\^' | \
    $(SORT) -Vr | \
    head -1
endef

# note: assembly for i686 targets is not officially supported
define $(PKG)_BUILD
    # disable obsolete cmake policies for CMake 4.x
    $(SED) -i 's/cmake_policy(SET CMP0025 OLD)/#cmake_policy(SET CMP0025 OLD)/g' '$(SOURCE_DIR)/source/CMakeLists.txt'
    $(SED) -i 's/cmake_policy(SET CMP0054 OLD)/#cmake_policy(SET CMP0054 OLD)/g' '$(SOURCE_DIR)/source/CMakeLists.txt'

    cd '$(BUILD_DIR)' && mkdir -p 10bit 12bit

    # 12 bit
    cd '$(BUILD_DIR)/12bit' && $(TARGET)-cmake '$(SOURCE_DIR)/source' \
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
        -DHIGH_BIT_DEPTH=ON \
        -DEXPORT_C_API=OFF \
        -DENABLE_SHARED=OFF \
        -DENABLE_ASSEMBLY=$(if $(findstring x86_64,$(TARGET)),ON,OFF) \
        -DENABLE_CLI=OFF \
        -DENABLE_HDR10_PLUS=ON \
        -DMAIN12=ON
    $(MAKE) -C '$(BUILD_DIR)/12bit' -j '$(JOBS)'
    cp '$(BUILD_DIR)/12bit/libx265.a' '$(BUILD_DIR)/libx265_main12.a'

    # 10 bit
    cd '$(BUILD_DIR)/10bit' && $(TARGET)-cmake '$(SOURCE_DIR)/source' \
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
        -DHIGH_BIT_DEPTH=ON \
        -DEXPORT_C_API=OFF \
        -DENABLE_SHARED=OFF \
        -DENABLE_ASSEMBLY=$(if $(findstring x86_64,$(TARGET)),ON,OFF) \
        -DENABLE_CLI=OFF \
        -DENABLE_HDR10_PLUS=ON
    $(MAKE) -C '$(BUILD_DIR)/10bit' -j '$(JOBS)'
    cp '$(BUILD_DIR)/10bit/libx265.a' '$(BUILD_DIR)/libx265_main10.a'

    # 8bit
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)/source' \
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
        -DHIGH_BIT_DEPTH=OFF \
        -DEXPORT_C_API=ON \
        -DENABLE_SHARED=$(CMAKE_SHARED_BOOL) \
        -DENABLE_ASSEMBLY=$(if $(findstring x86_64,$(TARGET)),ON,OFF) \
        -DENABLE_CLI=ON \
        -DENABLE_HDR10_PLUS=ON \
        -DEXTRA_LIB='x265_main10.a;x265_main12.a' \
        -DEXTRA_LINK_FLAGS=-L'$(BUILD_DIR)' \
        -DLINKED_10BIT=ON \
        -DLINKED_12BIT=ON

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' install
    $(if $(BUILD_SHARED),rm -f '$(PREFIX)/$(TARGET)/lib/libx265.a',\
        $(INSTALL) '$(BUILD_DIR)/libx265_main12.a' '$(PREFIX)/$(TARGET)/lib/libx265_main12.a' && \
        $(INSTALL) '$(BUILD_DIR)/libx265_main10.a' '$(PREFIX)/$(TARGET)/lib/libx265_main10.a' && \
        $(SED) -i 's|-lx265|-lx265 -lx265_main10 -lx265_main12|' '$(PREFIX)/$(TARGET)/lib/pkgconfig/x265.pc')
endef

