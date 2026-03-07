# This file is part of MXE. See LICENSE.md for licensing information.

include src/common/pkgutils.mk

PKG             := cuew
$(PKG)_DESCR    := CUDA Extension Wrangler Library (CUEW) for runtime CUDA API/extension loading
$(PKG)_WEBSITE  := https://github.com/CudaWrangler/cuew
$(PKG)_IGNORE   :=
$(PKG)_URL      := https://github.com/CudaWrangler/cuew/archive/refs/heads/master.tar.gz
# Using master because there are no tags yet (https://github.com/CudaWrangler/cuew/issues/11)
$(PKG)_VERSION  := master
$(PKG)_CHECKSUM := b9f8ac63ebdcad04642bf6bac47189d01e30a46f869174a2e852b147d4c41db4
$(PKG)_GH_CONF  := CudaWranglercuew/cuew/tags
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    # Configure with CMake
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DBUILD_STATIC_LIBS=$(CMAKE_STATIC_BOOL)

    # Build available targets (cuew only builds test executable; library is not automatically created)
    $(MAKE) -C "$(BUILD_DIR)" -j "$(JOBS)"

    # cuew CMakeLists.txt does not provide an 'install' target.
	# manually create the static library from object files for MXE installation.
    mkdir -p "$(BUILD_DIR)/CMakeFiles/cuew.dir/src"
    $(TARGET)-ar rcs "$(BUILD_DIR)/libcuew.a" "$(BUILD_DIR)/CMakeFiles/cuew.dir/src/"*.obj

    # Mimic install: copy library and headers
    mkdir -p '$(PREFIX)/$(TARGET)/lib'
    mkdir -p '$(PREFIX)/$(TARGET)/include'
    cp -f "$(BUILD_DIR)/libcuew.a" '$(PREFIX)/$(TARGET)/lib/'
    cp -Rf "$(SOURCE_DIR)/include/"* '$(PREFIX)/$(TARGET)/include/'

    # Generate pkg-config (.pc) file for cuew
    $(call GENERATE_PC, \
        $(PREFIX)/$(TARGET), \
        cuew, \
        CUDA Extension Wrangler Library, \
        $($(PKG)_VERSION), \
        "", \
        -lcuew, \
        "")

	# Build the test executable
	 $(TARGET)-g++ -Wall \
        '$(SOURCE_DIR)/cuewTest/cuewTest.c' \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `$(TARGET)-pkg-config $(PKG) --cflags --libs`

endef
