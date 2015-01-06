# This file is part of MXE.
# See index.html for further information.

PKG             := opus
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1
$(PKG)_CHECKSUM := 35005f5549e2583f5770590135984dcfce6f3d58
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://downloads.xiph.org/releases/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://downloads.xiph.org/releases/opus/?C=M;O=D' | \
    $(SED) -n 's,.*opus-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v 'alpha' | \
    grep -v 'beta' | \
    grep -v 'rc' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_CRUFT)
    rm -f '$(PREFIX)/$(TARGET)'/share/man/man3/opus_*.3
    rm -f '$(PREFIX)/$(TARGET)'/share/man/man3/opus.h.3
    rm -rf '$(PREFIX)/$(TARGET)'/share/doc/opus/html
endef
