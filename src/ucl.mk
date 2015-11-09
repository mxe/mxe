# This file is part of MXE.
# See index.html for further information.

PKG             := ucl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.03
$(PKG)_CHECKSUM := b865299ffd45d73412293369c9754b07637680e5c826915f097577cd27350348
$(PKG)_SUBDIR   := ucl-$($(PKG)_VERSION)
$(PKG)_FILE     := ucl-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.oberhumer.com/opensource/ucl/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.oberhumer.com/opensource/ucl/' | \
    $(SED) -n 's,.*ucl-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && \
        ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' LDFLAGS=-no-undefined
    $(MAKE) -C '$(1)' -j 1 install
endef
