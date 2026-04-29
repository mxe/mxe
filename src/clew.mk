# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

include src/common/pkgconfig-generator.mk

PKG             := clew
$(PKG)_DESCR    := OpenCL Extension Wrangler Library (CLEW) for OpenCL runtime extension loading
$(PKG)_WEBSITE  := https://github.com/hkunz/clew
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.11
$(PKG)_CHECKSUM := ee056db60b4f70c988f71a13c19c52b73401bc88e79369e3680886b59d69e53b
# Using fork from hkunz/clew instead of the original martijnberger/clew to work around https://github.com/martijnberger/clew/issues/19 and https://github.com/martijnberger/clew/issues/21
$(PKG)_GH_CONF  := hkunz/clew/tags,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
	cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DBUILD_STATIC_LIBS=$(CMAKE_STATIC_BOOL)

	$(MAKE) -C "$(BUILD_DIR)" -j "$(JOBS)"
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# note cuew.pc is also generated in hkunz/clew fork (https://github.com/martijnberger/clew/issues/21)
	# clew library already automatically compiles a test executable:
	# $(PREFIX)/$(TARGET)/bin/clewTest.exe
endef
