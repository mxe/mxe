# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := opencore-amr
$(PKG)_WEBSITE  := https://opencore-amr.sourceforge.io/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.6
$(PKG)_CHECKSUM := 483eb4061088e2b34b358e47540b5d495a96cd468e361050fae615b1809dc4a1
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/opencore-amr/files/opencore-amr/' | \
    $(SED) -n 's,.*opencore-amr-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
