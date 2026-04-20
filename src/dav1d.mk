# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

PKG             := dav1d
$(PKG)_WEBSITE  := https://www.videolan.org/projects/dav1d.html
$(PKG)_DESCR    := Cross-platform AV1 decoder optimized for speed and accuracy
$(PKG)_VERSION  := 1.5.3
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := cbe212b02faf8c6eed5b6d55ef8a6e363aaab83f15112e960701a9c3df813686
$(PKG)_GH_CONF  := videolan/dav1d/tags
$(PKG)_DEPS     := cc meson-wrapper $(BUILD)~nasm

define $(PKG)_BUILD

	# configure package with meson
	$(MXE_MESON_WRAPPER) $(MXE_MESON_OPTS) \
		-Denable_asm=true \
		-Denable_tools=true \
		-Denable_examples=false \
		-Denable_tests=true \
		-Denable_seek_stress=false \
		-Denable_docs=false \
		-Dlogging=true \
		-Dtestdata_tests=false \
		-Dmacos_kperf=false \
		--buildtype=release \
		"$(BUILD_DIR)" "$(SOURCE_DIR)"

	# build package and install
	$(MXE_NINJA) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MXE_NINJA) -C "$(BUILD_DIR)" -j 1 install

	# compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "$(PKG)" --cflags --libs`
endef
