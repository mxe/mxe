# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sdl3_ttf
$(PKG)_WEBSITE  := https://www.libsdl.org/
$(PKG)_DESCR    := SDL3_ttf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.2
$(PKG)_SUBDIR   := SDL3_ttf-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL3_ttf-$($(PKG)_VERSION).tar.gz
$(PKG)_CHECKSUM := 63547d58d0185c833213885b635a2c0548201cc8f301e6587c0be1a67e1e045d
$(PKG)_GH_CONF  := libsdl-org/SDL_ttf/releases/tag,release-,,
$(PKG)_DEPS     := cc freetype harfbuzz sdl3

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
