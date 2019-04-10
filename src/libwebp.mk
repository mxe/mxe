# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libwebp
$(PKG)_WEBSITE  := https://developers.google.com/speed/webp/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.2
$(PKG)_CHECKSUM := 3d47b48c40ed6476e8047b2ddb81d93835e0ca1b8d3e8c679afbb3004dd564b1
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://storage.googleapis.com/downloads.webmproject.org/releases/webp/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://developers.google.com/speed/webp/download' | \
    $(SED) -n 's,.*<a href="//storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-\([0-9][^"]*\)\.tar.gz">Download</a> |,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-everything
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=
endef
