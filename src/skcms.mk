# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

include src/common/pkgconfig-generator.mk

PKG             := skcms
$(PKG)_WEBSITE  := https://github.com/google/skcms
$(PKG)_DESCR    := Simple color management system by Google
$(PKG)_VERSION  := 2025_09_16
$(PKG)_CHECKSUM := 08c45dff8ede1b56a6e7d1e9fdaf113dd91ab28ddcbcf696229b683e5e9af45a
$(PKG)_GH_CONF  := google/skcms/tags
$(PKG)_DEPS     := cc

define $(PKG)_BUILD

    # Build static library manually because Bazel projects use network which is not allowed on MXE

    # Compile main skcms.cc
    $(TARGET)-c++ -c '$(SOURCE_DIR)/skcms.cc' \
        -O3 -std=c++17 -DSKCMS_IMPLEMENTATION=1 \
        -I'$(SOURCE_DIR)' -I'$(SOURCE_DIR)/src' \
        -o '$(BUILD_DIR)/skcms.o'

    # Compile TransformBaseline
    $(TARGET)-c++ -c '$(SOURCE_DIR)/src/skcms_TransformBaseline.cc' \
        -O3 -std=c++17 -DSKCMS_IMPLEMENTATION=1 \
        -I'$(SOURCE_DIR)' -I'$(SOURCE_DIR)/src' \
        -o '$(BUILD_DIR)/skcms_TransformBaseline.o'

    # Compile TransformHsw (AVX2, F16C)
    $(TARGET)-c++ -c '$(SOURCE_DIR)/src/skcms_TransformHsw.cc' \
        -O3 -std=c++17 -DSKCMS_IMPLEMENTATION=1 \
        -I'$(SOURCE_DIR)' -I'$(SOURCE_DIR)/src' \
        -mavx2 -mf16c \
        -o '$(BUILD_DIR)/skcms_TransformHsw.o'

    # Compile TransformSkx (AVX512)
    $(TARGET)-c++ -c '$(SOURCE_DIR)/src/skcms_TransformSkx.cc' \
        -O3 -std=c++17 -DSKCMS_IMPLEMENTATION=1 \
        -I'$(SOURCE_DIR)' -I'$(SOURCE_DIR)/src' \
        -mavx512f -mavx512dq -mavx512cd -mavx512bw -mavx512vl \
        -o '$(BUILD_DIR)/skcms_TransformSkx.o'

    # Archive all object files into static library
    $(TARGET)-ar rcs '$(BUILD_DIR)/libskcms.a' \
        '$(BUILD_DIR)/skcms.o' \
        '$(BUILD_DIR)/skcms_TransformBaseline.o' \
        '$(BUILD_DIR)/skcms_TransformHsw.o' \
        '$(BUILD_DIR)/skcms_TransformSkx.o'

    tmpfile=$(mktemp)
    $(SED) 's|"src/skcms_public.h"|"skcms_public.h"|' "$(SOURCE_DIR)/skcms.h" > "$tmpfile"
    mv "$tmpfile" "$(SOURCE_DIR)/skcms.h"

    # Install headers
    mkdir -p '$(PREFIX)/$(TARGET)/include/skcms'
    cp '$(SOURCE_DIR)/skcms.h' '$(PREFIX)/$(TARGET)/include/skcms/'
    cp '$(SOURCE_DIR)/src/skcms_public.h' '$(PREFIX)/$(TARGET)/include/skcms/'
    cp '$(SOURCE_DIR)/src/skcms_internals.h' '$(PREFIX)/$(TARGET)/include/skcms/'
    cp '$(SOURCE_DIR)/src/skcms_Transform.h' '$(PREFIX)/$(TARGET)/include/skcms/'
    cp '$(SOURCE_DIR)/src/Transform_inl.h' '$(PREFIX)/$(TARGET)/include/skcms/'


    mkdir -p '$(PREFIX)/$(TARGET)/lib'
    cp '$(BUILD_DIR)/libskcms.a' '$(PREFIX)/$(TARGET)/lib/'

    $(call GENERATE_PC, \
        $(PREFIX)/$(TARGET), \
        $(PKG), \
        $($(PKG)_DESCR), \
        $($(PKG)_VERSION), \
        , \
        , \
        -lskcms, \
    )

    # compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "$(PKG)" --cflags --libs`
endef
