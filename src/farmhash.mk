# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

include src/common/pkgconfig-generator.mk

PKG             := farmhash
$(PKG)_WEBSITE  := https://github.com/google/farmhash.git
$(PKG)_DESCR    := Fast, non-cryptographic hash functions for strings and binary data.
$(PKG)_VERSION  := master
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 88a7846c155001bc5d3a716cac2b696bdd558b9b3daca643104fb32dcb1bef75
$(PKG)_GH_CONF  := google/farmhash/tags
$(PKG)_DEPS     := cc

define $(PKG)_BUILD

	# Patch: Rename static variable 'data' -> 'mydata'
	# Reason: 'data' conflicts with std::data() in C++17+,
	# causing ambiguous reference errors when cross-compiling with MXE.
	tmp=$(mktemp) || exit 1
	$(SED) "s/\bdata\b/mydata/g" "$(SOURCE_DIR)/src/farmhash.cc" > "$tmp" && mv "$tmp" "$(SOURCE_DIR)/src/farmhash.cc"

	# Configure package
	cd "$(BUILD_DIR)" && "$(SOURCE_DIR)/configure" \
		$(MXE_CONFIGURE_OPTS) \
		--host="$(TARGET)" \
		--prefix="$(PREFIX)/$(TARGET)"

	# Build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j "$(JOBS)"
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	rm -rf "$(PREFIX)/$(TARGET)/share/doc/farmhash"

	# Only needed if the project does not ship a .pc file
	$(call GENERATE_PC, \
		"$(PREFIX)/$(TARGET)", \
		"$(PKG)", \
		"$($(PKG)_DESCR)", \
		"$($(PKG)_VERSION)", \
		, \
		, \
		-lfarmhash, \
	)

	# compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "$(PKG)" --cflags --libs`
endef
