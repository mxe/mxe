# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libplist
$(PKG)_WEBSITE  := https://github.com/libimobiledevice/libplist
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.12
$(PKG)_CHECKSUM := b8e860ef2e01154e79242438252b2a7ed185df351f02c167147a8a602a0aa63e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/libimobiledevice/libplist/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc libxml2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/libimobiledevice/libplist/archive/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/"\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && $(SHELL) ./autogen.sh \
        $(MXE_CONFIGURE_OPTS) \
        --without-cython
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
