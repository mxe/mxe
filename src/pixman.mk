# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pixman
$(PKG)_WEBSITE  := https://cairographics.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.33.6
$(PKG)_CHECKSUM := 4e1e72c0ed31d10944f304976e87e6c87b441c853713eeecf115e22c23d4b17d
$(PKG)_SUBDIR   := pixman-$($(PKG)_VERSION)
$(PKG)_FILE     := pixman-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://cairographics.org/snapshots/$($(PKG)_FILE)
$(PKG)_URL_2    := https://xorg.freedesktop.org/archive/individual/lib/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libpng

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://cairographics.org/snapshots/?C=M;O=D' | \
    $(SED) -n 's,.*"pixman-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
