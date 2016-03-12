# This file is part of MXE.
# See index.html for further information.

PKG             := librosco
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.11
$(PKG)_CHECKSUM := 48bb2d07c2575f39bdb6cf022889f20bd855eb9100bb19d4e2536a771198e3a4
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/colinbourassa/librosco/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, colinbourassa/librosco)
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && '$(TARGET)-cmake' .. \
        -DBUILD_STATIC=$(if $(BUILD_STATIC),ON,OFF) \
        -DENABLE_DOC_INSTALL=off \
        -DENABLE_TESTAPP_INSTALL=off

    $(MAKE) -C '$(1)/build' -j '$(JOBS)'
    $(MAKE) -C '$(1)/build' -j 1 install

    '$(TARGET)-gcc' $(1)/src/readmems.c \
        -o '$(PREFIX)/$(TARGET)/bin/test-librosco.exe' \
            `'$(TARGET)-pkg-config' --libs librosco`
endef
