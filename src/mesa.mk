PKG             := mesa
$(PKG)_VERSION  := 17.3.0
$(PKG)_CHECKSUM := 29a0a3a6c39990d491a1a58ed5c692e596b3bfc6c01d0b45e0b787116c50c6d9
$(PKG)_SUBDIR   := mesa-$($(PKG)_VERSION)
$(PKG)_FILE     := mesa-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := ftp://ftp.freedesktop.org/pub/mesa/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_BUILD
    cd '$(1)' && \
    MINGW_PREFIX='$(TARGET)-' scons platform=windows toolchain=crossmingw machine=x86_64 verbose=1 build=release libgl-gdi
    $(INSTALL) -m 755 '$(1)/build/windows-x86_64/gallium/targets/libgl-gdi/opengl32.dll' '$(PREFIX)/$(TARGET)/bin/'
endef
