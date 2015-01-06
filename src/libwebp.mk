# This file is part of MXE.
# See index.html for further information.

PKG             := libwebp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.4.1
$(PKG)_CHECKSUM := 6d3a8a0c25ec4e2eb7a04d9e7f52d780a9d6c0ed
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://downloads.webmproject.org/releases/webp/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://developers.google.com/speed/webp/download' | \
    $(SED) -n 's,.*<a href="http://downloads.webmproject.org/releases/webp/libwebp-\([0-9][^"]*\)\.tar.gz">Download</a> |,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-everything
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=
endef