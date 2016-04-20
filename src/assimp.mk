# This file is part of MXE.
# See index.html for further information.

PKG             := assimp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2
$(PKG)_CHECKSUM := 187f825c563e84b1b17527a4da0351aa3d575dfd696a9d204ae4bb19ee7df94a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/$(PKG)/$(PKG)/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc boost

define $(PKG)_UPDATE
    $(WGET) -q -O- "https://api.github.com/repos/assimp/assimp/releases" | \
    grep 'tag_name' | \
    $(SED) -n 's,.*tag_name": "v\([0-9][^>]*\)".*,\1,p' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && $(TARGET)-cmake $(1) \
        -DASSIMP_ENABLE_BOOST_WORKAROUND=OFF \
        -DASSIMP_BUILD_ASSIMP_TOOLS=OFF \
        -DASSIMP_BUILD_SAMPLES=OFF      \
        -DASSIMP_BUILD_TESTS=OFF        \
        -DBUILD_SHARED_LIBS=$(if $(BUILD_STATIC),OFF,ON)
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install VERBOSE=1

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-assimp.exe' \
        `'$(TARGET)-pkg-config' assimp --cflags --libs`
endef
