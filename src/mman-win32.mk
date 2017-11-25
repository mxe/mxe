# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mman-win32
$(PKG)_WEBSITE  := https://code.google.com/p/mman-win32/
$(PKG)_DESCR    := MMA-Win32
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := b7ec370
$(PKG)_CHECKSUM := 6f94db28ddf30711c7b227e97c5142f72f77aca2c5cc034a7d012db242cc2f7b
$(PKG)_SUBDIR   := witwall-mman-win32-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/witwall/mman-win32/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

$(PKG)_UPDATE = $(call MXE_GET_GITHUB_SHA, witwall/mman-win32, master) | $(SED) 's/^\(.......\).*/\1/;'

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(TARGET)-cmake' '$(1)'\
        -DBUILD_TESTS=OFF
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install

    '$(TARGET)-gcc' -W -Wall \
        '$(1)/test.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        -lmman
endef
