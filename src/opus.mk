# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := opus
$(PKG)_WEBSITE  := https://opus-codec.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3
$(PKG)_CHECKSUM := 4f3d69aefdf2dbaf9825408e452a8a414ffc60494c70633560700398820dc550
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://archive.mozilla.org/pub/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://archive.mozilla.org/pub/opus/?C=M;O=D' | \
    $(SED) -n 's,.*opus-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v 'alpha' | \
    grep -v 'beta' | \
    grep -v 'rc' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && $(SHELL) ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' SHELL=$(SHELL) $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(1)' -j 1 install SHELL=$(SHELL) $(MXE_DISABLE_CRUFT)
    rm -f '$(PREFIX)/$(TARGET)'/share/man/man3/opus_*.3
    rm -f '$(PREFIX)/$(TARGET)'/share/man/man3/opus.h.3
    rm -rf '$(PREFIX)/$(TARGET)'/share/doc/opus/html
endef
