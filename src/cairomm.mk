# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cairomm
$(PKG)_WEBSITE  := https://cairographics.org/cairomm/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.11.2
$(PKG)_CHECKSUM := ccf677098c1e08e189add0bd146f78498109f202575491a82f1815b6bc28008d
$(PKG)_SUBDIR   := cairomm-$($(PKG)_VERSION)
$(PKG)_FILE     := cairomm-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://cairographics.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := cc cairo libsigc++

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://cairographics.org/releases/?C=M;O=D' | \
    $(SED) -n 's,.*"cairomm-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_CRUFT)
endef

