# This file is part of MXE. See LICENSE.md for licensing information.

# WARNING: Like openssl, the license of this package is not compatible with
# GPL 2+, but it is with LGPL 2.1+. See docs/index.html#potential-legal-issues

PKG             := fdk-aac
$(PKG)_WEBSITE  := https://github.com/mstorsjo/fdk-aac
$(PKG)_DESCR    := FDK-AAC
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.0
$(PKG)_CHECKSUM := f7d6e60f978ff1db952f7d5c3e96751816f5aef238ecf1d876972697b85fd96c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/opencore-amr/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/opencore-amr/files/fdk-aac/' | \
    $(SED) -n 's,.*fdk-aac-\([0-9.]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        CXXFLAGS='-Wno-narrowing'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
