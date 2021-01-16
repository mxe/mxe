# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mesa
$(PKG)_WEBSITE  := https://mesa3d.org
$(PKG)_DESCR    := The Mesa 3D Graphics Library
$(PKG)_VERSION  := 20.3.0
$(PKG)_CHECKSUM := 2999738e888731531cd62b27519fa37566cc0ea2cd7d4d97f46abaa3e949c630
$(PKG)_SUBDIR   := mesa-$($(PKG)_VERSION)
$(PKG)_FILE     := mesa-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://archive.mesa3d.org/$($(PKG)_FILE)
$(PKG)_DEPS     := cc $(BUILD)~python-mako scons-local

define $(PKG)_UPDATE
    $(call GET_LATEST_VERSION, https://archive.mesa3d.org, mesa-)
endef

define $(PKG)_BUILD
    $(SCONS_PREP)
    cd '$(SOURCE_DIR)' && \
    MINGW_PREFIX='$(TARGET)-' $(SCONS_LOCAL) \
        -j $(JOBS) \
        platform=windows \
        toolchain=crossmingw \
        machine=$(if $(findstring x86_64,$(TARGET)),x86_64,x86) \
        verbose=1 \
        build=release \
        libgl-gdi \
        $(PKG_SCONS_OPTS)

    for i in EGL GLES GLES2 GLES3 KHR; do \
        $(INSTALL) -d "$(PREFIX)/$(TARGET)/include/$$i"; \
        $(INSTALL) -m 644 "$(1)/include/$$i/"* "$(PREFIX)/$(TARGET)/include/$$i/"; \
    done
    $(INSTALL) -m 755 '$(1)/build/windows-$(if $(findstring x86_64,$(TARGET)),x86_64,x86)/gallium/targets/libgl-gdi/opengl32.dll' '$(PREFIX)/$(TARGET)/bin/'
endef
