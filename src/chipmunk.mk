# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := chipmunk
$(PKG)_WEBSITE  := https://chipmunk-physics.net/
$(PKG)_DESCR    := Chipmunk Physics
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.2.2
$(PKG)_CHECKSUM := c51f0e3a30770f6b940de3228bee40a871aaf7611a1b5ec546a7d2b9e1041f97
$(PKG)_SUBDIR   := Chipmunk2D-Chipmunk-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/slembcke/Chipmunk2D/archive/Chipmunk-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/slembcke/Chipmunk2D/releases' | \
    $(SED) -n 's,.*/archive/Chipmunk-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && '$(TARGET)-cmake' .. \
        -DBUILD_DEMOS=OFF \
        -DINSTALL_DEMOS=OFF \
        $(if $(BUILD_STATIC), \
            -DINSTALL_STATIC=ON, \
            -DINSTALL_STATIC=OFF)

    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic -std=c99 \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-chipmunk.exe' \
        -lchipmunk
endef
