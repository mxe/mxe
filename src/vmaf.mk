# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

PKG             := vmaf
$(PKG)_WEBSITE  := https://github.com/Netflix/vmaf.git
$(PKG)_DESCR    := Perceptual video quality assessment based on multi-method fusion.
$(PKG)_VERSION  := 3.1.0
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 80090e29d7fd0db472ddc663513f5be89bc936815e62b767e630c1d627279fe2
$(PKG)_GH_CONF  := Netflix/vmaf/tags,v
$(PKG)_DEPS     := cc meson-wrapper

define $(PKG)_BUILD

	# configure package with meson
	$(MXE_MESON_WRAPPER) $(MXE_MESON_OPTS) \
		-Denable_tests=true \
		-Denable_docs=true \
		-Denable_tools=true \
		-Denable_asm=true \
		-Denable_avx512=true \
		-Dbuilt_in_models=true \
		-Denable_float=false \
		-Denable_cuda=false \
		-Denable_nvtx=false \
		-Denable_nvcc=true \
		--buildtype=release \
		"$(BUILD_DIR)" "$(SOURCE_DIR)/libvmaf"

	# build package and install
	$(MXE_NINJA) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MXE_NINJA) -C "$(BUILD_DIR)" -j 1 install

	# compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "lib$(PKG)" --cflags --libs`
endef
