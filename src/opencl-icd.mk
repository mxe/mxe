# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := opencl-icd
$(PKG)_WEBSITE  := https://www.khronos.org/registry/OpenCL/
$(PKG)_DESCR    := Khronos OpenCL ICD Loader
# disable updates since https://github.com/KhronosGroup/OpenCL-ICD-Loader/commit/188be60
# uses apis not in mingw-w64 yet.
$(PKG)_IGNORE   := %
$(PKG)_VERSION  := 6849f61
$(PKG)_CHECKSUM := e44fb2a74100e88866f768825a2d373dc532c21a131950d3ea0a59e5ec6fed8c
$(PKG)_GH_CONF  := KhronosGroup/OpenCL-ICD-Loader/master
$(PKG)_DEPS     := gcc opencl-headers

# i686 target seems to need stdcall @ annotated *.def file
$(PKG)_DEF_FILE := $(dir $(lastword $(MAKEFILE_LIST)))/opencl32.def

define $(PKG)_BUILD
    # add *.def file to sources for linking
    #cp '$(SOURCE_DIR)/OpenCL.def' '$(SOURCE_DIR)/test/loader_test/'
    #$(SED) -i 's,main.c, main.c OpenCL.def,' '$(SOURCE_DIR)/test/loader_test/CMakeLists.txt'

    # install *.def file in case downstream packages need it
    $(INSTALL) -m644 \
    $(if $(findstring i686,$(TARGET)), \
        $($(PKG)_DEF_FILE) \
    $(else), \
        '$(SOURCE_DIR)/OpenCL.def') '$(PREFIX)/$(TARGET)/include/CL/OpenCL.def'

    # create import lib and patch build to use it instead of *.def
    '$(TARGET)-dlltool' \
        -l '$(PREFIX)/$(TARGET)/lib/libOpenCL.a' \
        -d '$(PREFIX)/$(TARGET)/include/CL/OpenCL.def'

    # build loader test and install
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DOPENCL_INCLUDE_DIRS='$(PREFIX)/$(TARGET)/include/CL' \
        -DCMAKE_C_FLAGS='-D_WIN32_WINNT=0x0600 -Wl,--enable-stdcall-fixup'

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    rm -rf '$(PREFIX)/$(TARGET)/bin/test-$(PKG)'
    cp -Rv '$(BUILD_DIR)/bin' '$(PREFIX)/$(TARGET)/bin/test-$(PKG)'
endef
