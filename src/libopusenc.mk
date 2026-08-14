# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libopusenc
$(PKG)_WEBSITE  := https://opus-codec.org/
$(PKG)_DESCR    := High-level API for encoding .opus files
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.3
$(PKG)_CHECKSUM := f616d3aff9b2034547894ccb8ab56c36cf1a4acb0d922c5d7119f97bbe58642c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://downloads.xiph.org/releases/opus/$($(PKG)_FILE)
$(PKG)_DEPS     := cc opus

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://downloads.xiph.org/releases/opus/' | \
    $(SED) -n 's,.*libopusenc-\([0-9][^>]*\)\.tar\.gz.*,\1,p' | \
    grep -v 'alpha' | \
    grep -v 'beta' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-doc
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
