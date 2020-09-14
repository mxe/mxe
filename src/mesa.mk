PKG             := mesa
$(PKG)_VERSION  := 18.3.6
$(PKG)_CHECKSUM := aaf17638dcf5a90b93b6389e152fdc9ef147768b09598f24d2c5cf482fcfc705
$(PKG)_SUBDIR   := mesa-$($(PKG)_VERSION)
$(PKG)_FILE     := mesa-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := ftp://ftp.freedesktop.org/pub/mesa/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc scons-local

define $(PKG)_BUILD
    mkdir -p '$(BUILD_DIR).scons'
    $(call PREPARE_PKG_SOURCE,scons-local,'$(BUILD_DIR).scons')
    cd '$(1)' && \
    MINGW_PREFIX='$(TARGET)-' $(SCONS_LOCAL) \
        platform=windows \
        toolchain=crossmingw \
        machine=$(if $(findstring x86_64,$(TARGET)),x86_64,x86) \
        verbose=1 \
        build=release \
        libgl-gdi

    for i in EGL GLES GLES2 GLES3 KHR; do \
        $(INSTALL) -d "$(PREFIX)/$(TARGET)/include/$$i"; \
        $(INSTALL) -m 644 "$(1)/include/$$i/"* "$(PREFIX)/$(TARGET)/include/$$i/"; \
    done
    $(INSTALL) -m 755 '$(1)/build/windows-$(if $(findstring x86_64,$(TARGET)),x86_64,x86)/gallium/targets/libgl-gdi/opengl32.dll' '$(PREFIX)/$(TARGET)/bin/'
endef
