# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := muparser
$(PKG)_WEBSITE  := http://muparser.beltoforion.de/
$(PKG)_DESCR    := muParser
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.5
$(PKG)_CHECKSUM := 0666ef55da72c3e356ca85b6a0084d56b05dd740c3c21d26d372085aa2c6e708
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://github.com/beltoforion/$(PKG)/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, beltoforion/muparser, v)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-samples \
        --disable-debug
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
