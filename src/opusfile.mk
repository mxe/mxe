# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := opusfile
$(PKG)_WEBSITE  := https://opus-codec.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.10
$(PKG)_CHECKSUM := 48e03526ba87ef9cf5f1c47b5ebe3aa195bd89b912a57060c36184a6cd19412f
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://archive.mozilla.org/pub/opus/$($(PKG)_FILE)
$(PKG)_DEPS     := cc ogg opus

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://archive.mozilla.org/pub/opus/?C=M;O=D' | \
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
