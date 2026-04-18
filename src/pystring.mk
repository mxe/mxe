# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

include src/common/pkgconfig-generator.mk

PKG             := pystring
$(PKG)_WEBSITE  := https://github.com/imageworks/pystring.git
$(PKG)_DESCR    := C++ functions matching the interface and behavior of python string methods with std::string
$(PKG)_VERSION  := 1.1.5
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 63c30c251b8017c897bd923826f400aee1d6e4f1c22ffbbd2104f150522a2040
$(PKG)_GH_CONF  := imageworks/pystring/tags,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD

	# configure package with cmake
	cd "$(BUILD_DIR)" && "$(TARGET)-cmake" "$(SOURCE_DIR)" \
		-DCMAKE_INSTALL_PREFIX="$(PREFIX)/$(TARGET)" \
		-DCMAKE_PREFIX_PATH="$(PREFIX)/$(TARGET)" \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DCMAKE_BUILD_TYPE=Release

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# Only needed if the project does not ship a .pc file
	$(call GENERATE_PC, \
		$(PREFIX)/$(TARGET), \
		$(PKG), \
		$($(PKG)_DESCR), \
		$($(PKG)_VERSION), \
		, \
		, \
		-lpystring, \
	)

	# compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "$(PKG)" --cflags --libs`
endef
