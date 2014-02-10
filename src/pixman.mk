# This file is part of MXE.
# See index.html for further information.

PKG             := pixman
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.31.2
$(PKG)_CHECKSUM := 0246796a1220a52e8e98110dd1460b64e7f2476c
$(PKG)_SUBDIR   := pixman-$($(PKG)_VERSION)
$(PKG)_FILE     := pixman-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://cairographics.org/snapshots/$($(PKG)_FILE)
$(PKG)_URL_2    := http://xorg.freedesktop.org/archive/individual/lib/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://cairographics.org/snapshots/?C=M;O=D' | \
    $(SED) -n 's,.*"pixman-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
