# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := chafa
$(PKG)_WEBSITE  := https://hpjansson.org/chafa/
$(PKG)_DESCR    := The Chafa terminal graphics package
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.12.3
$(PKG)_CHECKSUM := 2456a0b6c1150e25b64cd6a92810d59bed3f061f8b86f91aba5a77bc7cc76cfa
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://hpjansson.org/chafa/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := cc glib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://hpjansson.org/chafa/releases/' | \
    $(SED) -n 's,.*chafa-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -rV | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --disable-gtk-doc \
        --disable-man \
        --without-tools \
        --without-imagemagick
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' LDFLAGS='-no-undefined'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef

