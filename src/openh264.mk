# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

PKG             := openh264
$(PKG)_WEBSITE  := https://www.openh264.org/
$(PKG)_DESCR    := H.264/AVC encoder/decoder library for real-time video
$(PKG)_VERSION  := 2.6.0
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 558544ad358283a7ab2930d69a9ceddf913f4a51ee9bf1bfb9e377322af81a69
$(PKG)_GH_CONF  := cisco/openh264/tags,v
$(PKG)_DEPS     := cc meson-wrapper

define $(PKG)_BUILD

	# configure package with meson
	$(MXE_MESON_WRAPPER) $(MXE_MESON_OPTS) \
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
