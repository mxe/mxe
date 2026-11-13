# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sdl3_image
$(PKG)_WEBSITE  := https://www.libsdl.org/
$(PKG)_DESCR    := SDL3_image
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.4
$(PKG)_SUBDIR   := SDL3_image-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL3_image-$($(PKG)_VERSION).tar.gz
$(PKG)_CHECKSUM := a725bd6d04261fdda0dd8d950659e1dc15a8065d025275ef460d32ae7dcfc182
$(PKG)_GH_CONF  := libsdl-org/SDL_image/releases,release-
$(PKG)_DEPS     := cc jpeg libpng libwebp sdl3 tiff

define $(PKG)_UPDATE
    git ls-remote --tags 'https://github.com/libsdl-org/SDL_image.git' | \
    $(SED) -n 's#.*refs/tags/release-\(3\.[0-9.]*\)$$#\1#p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DSDLIMAGE_DEPS_SHARED=$(CMAKE_SHARED_BOOL)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
