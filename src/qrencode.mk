# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qrencode
$(PKG)_WEBSITE  := https://fukuchi.org/works/qrencode/
$(PKG)_DESCR    := libqrencode
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4.4
$(PKG)_CHECKSUM := e794e26a96019013c0e3665cb06b18992668f352c5553d0a553f5d144f7f2a72
$(PKG)_SUBDIR   := qrencode-$($(PKG)_VERSION)
$(PKG)_FILE     := qrencode-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://fukuchi.org/works/qrencode/qrencode-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc libpng pthreads sdl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://fukuchi.org/works/qrencode/index.html' | \
    grep 'qrencode-' | \
    $(SED) -n 's,.*qrencode-\([0-9][^>]*\)\.tar.*,\1,p' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        CFLAGS='-pthread -lpng' \
        LDFLAGS='-L$(PREFIX)/$(TARGET)/lib' \
         --without-tools \
         --with-tests \
        $(MXE_CONFIGURE_OPTS) \
        CONFIG_SHELL=$(SHELL)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # create pkg-config files
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: libqrencode'; \
     echo 'Libs: -lqrencode -lpng';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'
endef
