# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libwebp
$(PKG)_WEBSITE  := https://developers.google.com/speed/webp/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.2
$(PKG)_CHECKSUM := 2a499607df669e40258e53d0ade8035ba4ec0175244869d1025d460562aa09b4
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://storage.googleapis.com/downloads.webmproject.org/releases/webp/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://storage.googleapis.com/downloads.webmproject.org/releases/webp/index.html' | \
    $(SED) -n 's,<a href="[^"]*libwebp-\([0-9.]\+\)\.tar.gz".*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-everything
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=
endef
