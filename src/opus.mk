# This file is part of MXE.
# See index.html for further information.

PKG             := opus
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 37dd3d69b10612cd513ccf26675ef6d61eda24b4
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://downloads.xiph.org/releases/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://downloads.xiph.org/releases/opus/?C=M;O=D' | \
    $(SED) -n 's,.*opus-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v 'alpha' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
