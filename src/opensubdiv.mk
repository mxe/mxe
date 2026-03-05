# This file is part of MXE. See LICENSE.md for licensing information.

include src/common/pkgutils.mk

PKG             := opensubdiv
$(PKG)_DESCR    := Pixar OpenSubdiv library for subdivision surface evaluation
$(PKG)_WEBSITE  := https://github.com/PixarAnimationStudios/OpenSubdiv
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3_7_0
$(PKG)_CHECKSUM := f843eb49daf20264007d807cbc64516a1fed9cdb1149aaf84ff47691d97491f9
$(PKG)_GH_CONF  := PixarAnimationStudios/OpenSubdiv/tags,v
$(PKG)_DEPS     := cc onetbb zlib glfw3 clew

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DCLEW_LIBRARY='$(PREFIX)/$(TARGET)/lib/libclew.a' \
        -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DBUILD_STATIC_LIBS=$(CMAKE_STATIC_BOOL) \
        -DOPENSUBDIV_PTEX_SUPPORT=OFF \
        -DNO_DX=1 \
        -DNO_OPENCL=1 \
        -DNO_CUDA=1 \
        -DNO_PTEX=1 \
        -DNO_REGRESSION=1 \
        -DNO_EXAMPLES=1 \
        -DNO_TUTORIALS=1 \
        -DNO_DOC=1 \
        -DNO_OPENGL=0

    $(MAKE) -C "$(BUILD_DIR)" -j "$(JOBS)"
    $(MAKE) -C "$(BUILD_DIR)" -j 1 install

    # Generate missing pkg-config (.pc) file for OpenSubdiv
    $(call GENERATE_PC, \
        $(PREFIX)/$(TARGET), \
        opensubdiv, \
        Pixar OpenSubdiv library for subdivision surface evaluation, \
        $($(PKG)_VERSION), \
        tbb zlib clew, \
        -losdCPU -ltbb12 -lz -lclew, \
        ""
    )

    # compile test
    '$(TARGET)-g++' -Wall \
        '$(TEST_FILE)' \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
