# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := opencl-clhpp
$(PKG)_WEBSITE  := https://www.khronos.org/registry/OpenCL/
$(PKG)_DESCR    := Khronos OpenCL C++ bindings
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8b6a312
$(PKG)_CHECKSUM := aa74ee135520092bf54845bdfaf783961ad1e18d436167547baf7ef982189778
$(PKG)_GH_CONF  := KhronosGroup/OpenCL-CLHPP/master
$(PKG)_DEPS     := gcc opencl-headers opencl-icd

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_DOCS=OFF \
        -DBUILD_EXAMPLES=ON \
        -DBUILD_TESTS=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' generate_cl2hpp generate_clhpp
    $(INSTALL) -m644 '$(BUILD_DIR)/include/CL/'*.hpp '$(PREFIX)/$(TARGET)/include/CL/'

    # only one of the examples works and needs posix features
    $(if $(findstring posix,$(TARGET)),
        $(MAKE) -C '$(BUILD_DIR)' trivialCL2SizeTCompat -j '$(JOBS)'
        $(INSTALL) -m755 '$(BUILD_DIR)/examples/src/trivialCL2SizeTCompat.exe' '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe')
endef
