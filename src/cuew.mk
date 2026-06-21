# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

include src/common/pkgconfig-generator.mk

PKG             := cuew
$(PKG)_WEBSITE  := https://github.com/CudaWrangler/cuew.git
$(PKG)_DESCR    := CUDA Extension Wrangler Library (CUEW) for runtime CUDA API/extension loading
$(PKG)_IGNORE   :=
# Using master because there are no tags yet (https://github.com/CudaWrangler/cuew/issues/11)
$(PKG)_VERSION  := master
$(PKG)_CHECKSUM := b9f8ac63ebdcad04642bf6bac47189d01e30a46f869174a2e852b147d4c41db4
$(PKG)_GH_CONF  := CudaWrangler/cuew/tags
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
	# Configure with CMake
	cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DBUILD_STATIC_LIBS=$(CMAKE_STATIC_BOOL) \
		-DCMAKE_BUILD_TYPE=Release

	# Build available targets (cuew only builds test executable; library is not automatically created)
	$(MAKE) -C "$(BUILD_DIR)" -j "$(JOBS)"

	# workaround until https://github.com/CudaWrangler/cuew/issues/11 is fixed
	# cuew CMakeLists.txt does not provide an 'install' target.
	# manually create the static library from object files for MXE installation.

	mkdir -p "$(BUILD_DIR)/CMakeFiles/cuew.dir/src"
	$(TARGET)-ar rcs "$(BUILD_DIR)/libcuew.a" "$(BUILD_DIR)/CMakeFiles/cuew.dir/src/"*.obj

	# Mimic install: copy library and headers
	$(INSTALL) -d "$(PREFIX)/$(TARGET)/lib"
	$(INSTALL) -m 644 "$(BUILD_DIR)/libcuew.a" "$(PREFIX)/$(TARGET)/lib/"
	$(INSTALL) -d "$(PREFIX)/$(TARGET)/include"
	cp -r "$(SOURCE_DIR)/include/." "$(PREFIX)/$(TARGET)/include/"

	# Generate pkg-config (.pc) file for cuew
	$(call GENERATE_PC, \
		$(PREFIX)/$(TARGET), \
		$(PKG), \
		$($(PKG)_DESCR), \
		$($(PKG)_VERSION), \
		, \
		, \
		-lcuew, \
	)

	# compile a test program to verify the library is usable
	"$(TARGET)-gcc" -Wall -Wextra "$(SOURCE_DIR)/cuewTest/cuewTest.c" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "$(PKG)" --cflags --libs`
endef
