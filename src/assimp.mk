# This file is part of MXE.
# See index.html for further information.

PKG             := assimp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.1
$(PKG)_CHECKSUM := 3b8d16eaf6c4b26479295f4f7436388bee1e42e8c0b11f6f695b7194985eb00e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).zip
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)-$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
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
        -DASSIMP_BUILD_STATIC_LIB=$(if $(BUILD_STATIC),ON,OFF)
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install VERBOSE=1

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-assimp.exe' \
        `'$(TARGET)-pkg-config' assimp --cflags --libs`
endef
