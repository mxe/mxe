# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libcdio
$(PKG)_WEBSITE  := https://www.gnu.org/software/libcdio/
$(PKG)_DESCR    := Libcdio
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.0
$(PKG)_CHECKSUM := 8550e9589dbd594bfac93b81ecf129b1dc9d0d51e90f9696f1b2f9b2af32712b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://ftp.gnu.org/gnu/libcdio/$(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(call GET_LATEST_VERSION, https://ftp.gnu.org/gnu/libcdio)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j 1 install
endef
