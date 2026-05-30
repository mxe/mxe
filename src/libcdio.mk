# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libcdio
$(PKG)_WEBSITE  := https://www.gnu.org/software/libcdio/
$(PKG)_DESCR    := Libcdio
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.0
$(PKG)_CHECKSUM := 53e83d284667535a767fd2d31edad1a6701591960459df373a10f1f21e80a7ed
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://github.com/libcdio/libcdio/releases/download/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_GH_CONF  := libcdio/libcdio/releases/latest
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j 1 install
endef
