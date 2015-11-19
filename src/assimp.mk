# This file is part of MXE.
# See index.html for further information.

PKG             := assimp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.1
$(PKG)_CHECKSUM := a8164e12389277951a0bc2e68b19c04031b0152f33e2a0e74ab55b2d449c3f4e
$(PKG)_DEPS     := gcc boost

$(PKG)_GH_REPO    := $(PKG)/$(PKG)
$(PKG)_GH_TAG_PFX := v
$(PKG)_GH_TAG_SHA := 1c4a8e9
$(eval $(MXE_SETUP_GITHUB))

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && $(TARGET)-cmake $(1) \
        -DASSIMP_ENABLE_BOOST_WORKAROUND=OFF \
        -DASSIMP_BUILD_ASSIMP_TOOLS=OFF \
        -DASSIMP_BUILD_SAMPLES=OFF      \
        -DASSIMP_BUILD_TESTS=OFF        \
        -DASSIMP_BUILD_STATIC_LIB=$(if $(BUILD_STATIC),ON,OFF)
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install VERBOSE=1

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-assimp.exe' \
        `'$(TARGET)-pkg-config' assimp --cflags --libs`
endef
