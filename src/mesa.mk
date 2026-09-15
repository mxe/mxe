# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mesa
$(PKG)_WEBSITE  := https://mesa3d.org
$(PKG)_DESCR    := The Mesa 3D Graphics Library
$(PKG)_VERSION  := 26.2.0
$(PKG)_CHECKSUM := efd4bb08cdb7c365a812cd4e6c9202ab55b2f22cdcd13c7d6c4f9647b799a4ef
$(PKG)_SUBDIR   := mesa-$($(PKG)_VERSION)
$(PKG)_FILE     := mesa-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://archive.mesa3d.org/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper zlib zstd llvm

define $(PKG)_UPDATE
    $(call GET_LATEST_VERSION, https://archive.mesa3d.org, mesa-)
endef

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Dllvm=false \
        -Dgallium-drivers=softpipe \
        -Dbuild-tests=false \
        -Dcpp_rtti=false \
        $(PKG_MESON_OPTS) \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'

    # manual install to avoid clobbering platform opengl driver
    for i in EGL GLES GLES2 GLES3 KHR; do \
        $(INSTALL) -d "$(PREFIX)/$(TARGET)/include/$$i"; \
        $(INSTALL) -m 644 "$(1)/include/$$i/"* "$(PREFIX)/$(TARGET)/include/$$i/"; \
    done

    $(if $(BUILD_SHARED), \
        $(INSTALL) -m 755 '$(BUILD_DIR)/src/gallium/targets/wgl/libgallium_wgl.dll' \
                          '$(PREFIX)/$(TARGET)/bin/'
        $(INSTALL) -m 755 '$(BUILD_DIR)/src/gallium/targets/libgl-gdi/opengl32.dll' \
                          '$(PREFIX)/$(TARGET)/bin/'
    )
endef
