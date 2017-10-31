# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gc
$(PKG)_WEBSITE  := http://www.hpl.hp.com/personal/Hans_Boehm/gc/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.6.0
$(PKG)_CHECKSUM := a14a28b1129be90e55cd6f71127ffc5594e1091d5d54131528c24cd0c03b7d90
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://hboehm.info/$(PKG)/$(PKG)_source/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libatomic_ops

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://hboehm.info/gc/gc_source/' | \
    grep '<a href="gc-' | \
    $(SED) -n 's,.*<a href="gc-\([0-9][^"]*\)\.tar.*,\1,p' | \
    grep -v 'alpha' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-threads=win32 \
        --enable-cplusplus
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
