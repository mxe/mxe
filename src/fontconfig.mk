# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := fontconfig
$(PKG)_WEBSITE  := https://fontconfig.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.15.0
$(PKG)_CHECKSUM := 63a0658d0e06e0fa886106452b58ef04f21f58202ea02a94c39de0d3335d7c0e
$(PKG)_SUBDIR   := fontconfig-$($(PKG)_VERSION)
$(PKG)_FILE     := fontconfig-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://fontconfig.org/release/$($(PKG)_FILE)
$(PKG)_DEPS     := cc expat freetype-bootstrap gettext

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://fontconfig.org/release/' | \
    $(SED) -n 's,.*fontconfig-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v '\([0-9]\+\.\)\{2\}9[0-9]' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-arch='$(TARGET)' \
        --with-expat='$(PREFIX)/$(TARGET)' \
        --disable-docs
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
