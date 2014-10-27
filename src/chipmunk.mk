# This file is part of MXE.
# See index.html for further information.

PKG             := chipmunk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.2.1
$(PKG)_CHECKSUM := 4b34fd79d232b523f80f4b7e21d7d7c866bfade0
$(PKG)_SUBDIR   := Chipmunk2D-Chipmunk-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/slembcke/Chipmunk2D/archive/Chipmunk-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/slembcke/Chipmunk2D/releases' | \
    $(SED) -n 's,.*/archive/Chipmunk-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBUILD_DEMOS=OFF \
        -DINSTALL_DEMOS=OFF \
        $(if $(BUILD_STATIC), \
            -DBUILD_SHARED=OFF \
            -DBUILD_STATIC=ON \
            -DINSTALL_STATIC=ON, \
            -DBUILD_SHARED=ON \
            -DBUILD_STATIC=OFF \
            -DINSTALL_STATIC=OFF)

    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic -std=c99 \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-chipmunk.exe' \
        -lchipmunk
endef
