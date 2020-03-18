# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := xz
$(PKG)_WEBSITE  := https://tukaani.org/xz/
$(PKG)_DESCR    := XZ
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.2.5
$(PKG)_CHECKSUM := f6f4910fd033078738bd82bfba4f49219d03b17eb0794eb91efbae419f4aba10
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://tukaani.org/xz/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://tukaani.org/xz/' | \
    $(SED) -n 's,.*xz-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-threads \
        --disable-nls
    $(MAKE) -C '$(1)'/src/liblzma -j '$(JOBS)' install
endef
