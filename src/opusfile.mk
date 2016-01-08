# This file is part of MXE.
# See index.html for further information.

PKG             := opusfile
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.6
$(PKG)_CHECKSUM := 2428717b356e139f18ed2fdb5ad990b5654a238907a0058200b39c46a7d03ea6
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://downloads.xiph.org/releases/opus/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc ogg opus

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://downloads.xiph.org/releases/opus/?C=M;O=D' | \
    $(SED) -n 's,.*opusfile-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v 'alpha' | \
    grep -v 'beta' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-doc \
        --disable-http
    $(MAKE) -C '$(1)' -j '$(JOBS)' noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install noinst_PROGRAMS=
endef
