# This file is part of MXE.
# See index.html for further information.

PKG             := itstool
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.0
$(PKG)_CHECKSUM := dc6b766c2acec32d3c5d016b0a33e9268d274f63
$(PKG)_SUBDIR   := itstool-$($(PKG)_VERSION)
$(PKG)_FILE     := itstool-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://files.itstool.org/itstool/$(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://itstool.org/download/' | \
    $(SED) -n 's,.*itstool-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

ifeq ($(MXE_SYSTEM),msvc)
    $(PKG)_PREFIX := $(HOST_PREFIX_NATIVE)
else
    $(PKG)_PREFIX := $(HOST_PREFIX)
endif

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --enable-static

    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
