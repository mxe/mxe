# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := fontconfig
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.12.0
$(PKG)_CHECKSUM := b433e4efff1f68fdd8aac221ed1df3ff1e580ffedbada020a703fe64017d8224
$(PKG)_SUBDIR   := fontconfig-$($(PKG)_VERSION)
$(PKG)_FILE     := fontconfig-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://fontconfig.org/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc expat freetype-bootstrap

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://fontconfig.org/release/' | \
    $(SED) -n 's,.*fontconfig-\([0-9][^>]*\)\.tar.*,\1,p' | \
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
