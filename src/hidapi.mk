# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := hidapi
$(PKG)_WEBSITE  := https://github.com/signal11/hidapi/
$(PKG)_DESCR    := HIDAPI
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := a6a622ffb680c55da0de787ff93b80280498330f
$(PKG)_CHECKSUM := a1d1ab45e0d52820f7b65049544ebfff3e6f56626fac1d2b4398c3360c0df5a1
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_VERSION).zip
$(PKG)_URL      := https://github.com/signal11/$(PKG)/archive/$($(PKG)_VERSION).zip
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(1)' && ./bootstrap && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
