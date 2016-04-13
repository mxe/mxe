# This file is part of MXE.
# See index.html for further information.

PKG             := libical
$(PKG)_VERSION  := 2.0.0
$(PKG)_CHECKSUM := 654c11f759c19237be39f6ad401d917e5a05f36f1736385ed958e60cf21456da
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/$(PKG)/$(PKG)/releases/download/v$($(PKG)_VERSION)//$($(PKG)_FILE)
$(PKG)_DEPS     := gcc icu4c

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, libical/libical, v)
endef

define $(PKG)_BUILD
    cd '$(1)' && mkdir build
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DUSE_BUILTIN_TZDATA=true \
        -DSTATIC_ONLY=$(if $(BUILD_STATIC),true,false) \
        -DSHARED_ONLY=$(if $(BUILD_STATIC),false,true)
    $(MAKE) -C '$(1)/build' -j '$(JOBS)'
    $(MAKE) -C '$(1)/build' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libical.exe' \
        `'$(TARGET)-pkg-config' libical --cflags --libs`
endef
