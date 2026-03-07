# This file is part of MXE. See LICENSE.md for licensing information.

include src/common/pkgutils.mk

PKG             := clew
$(PKG)_DESCR    := OpenCL Extension Wrangler Library (CLEW) for OpenCL runtime extension loading
$(PKG)_WEBSITE  := https://github.com/hkunz/clew
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.11
$(PKG)_CHECKSUM := 165f8f118e4b73560077200e570fa9dd63b5965a018e2e2713826e6a3a5f029c
# Using fork from hkunz/clew instead of the original martijnberger/clew to work around https://github.com/martijnberger/clew/issues/19
$(PKG)_GH_CONF  := hkunz/clew/tags
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DBUILD_STATIC_LIBS=$(CMAKE_STATIC_BOOL)

    $(MAKE) -C "$(BUILD_DIR)" -j "$(JOBS)"
    $(MAKE) -C "$(BUILD_DIR)" -j 1 install

    # Generate missing pkg-config (.pc) file for clew
    $(call GENERATE_PC, \
        $(PREFIX)/$(TARGET), \
        clew, \
        "OpenCL Extension Wrangler Library", \
        $($(PKG)_VERSION), \
        "", \
        "-lclew", \
        ""
    )

	# clew library already automatically compiles a test executable:
	# $(PREFIX)/$(TARGET)/bin/clewTest.exe
endef
