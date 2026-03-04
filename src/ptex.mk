# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ptex
$(PKG)_DESCR    := Pixar Ptex library for per-face textures
$(PKG)_WEBSITE  := https://github.com/wdas/ptex
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5.1
$(PKG)_CHECKSUM := 6b4b55f562a0f9492655fcb7686ecc335a2a4dacc1de9f9a057a32f3867a9d9e
$(PKG)_GH_CONF  := wdas/ptex/tags,v
$(PKG)_DEPS     := cc zlib libdeflate

define $(PKG)_BUILD
	# Patch Windows.h include to lowercase for MinGW (https://github.com/wdas/ptex/issues/85 is fixed but no tag yet)
    sed -i 's/#include <Windows.h>/#include <windows.h>/' '$(SOURCE_DIR)/src/ptex/PtexPlatform.h'

	cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
		-DCMAKE_BUILD_TYPE=Release \
		-DPTEX_BUILD_STATIC_LIBS=$(CMAKE_STATIC_BOOL) \
		-DPTEX_BUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DPTEX_BUILD_DOCS=OFF \
		-DPRMAN_15_COMPATIBLE_PTEX=OFF \

    $(MAKE) -C "$(BUILD_DIR)" -j "$(JOBS)"
    $(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# Ptex library automatically builds a test utility:
	# $(PREFIX)/$(TARGET)/bin/ptxinfo.exe
endef
