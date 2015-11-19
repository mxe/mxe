# This file is part of MXE.
# See index.html for further information.

PKG             := chipmunk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.2.2
$(PKG)_CHECKSUM := 961c9dd228199ed1f6e4a6260174bf31a16cc6dbb3785f513ee957437fecb200
$(PKG)_DEPS     := gcc

$(PKG)_GH_REPO    := slembcke/Chipmunk2D
$(PKG)_GH_TAG_PFX := Chipmunk-
$(PKG)_GH_TAG_SHA := 9b0d57e
$(eval $(MXE_SETUP_GITHUB))

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
