# This file is part of MXE.
# See index.html for further information.

PKG             := yasm
$(PKG)_VERSION  := 1.3.0
$(PKG)_CHECKSUM := b7574e9f0826bedef975d64d3825f75fbaeef55e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.tortall.net/projects/$(PKG)/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/yasm/yasm/tags' | \
    $(SED) -n 's,.*href="/yasm/yasm/archive/v\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # native build of yasm - will the same for all targets
    # but we don't want to conflict with an un-prefixed version
    mkdir '$(1).native'
    cd '$(1).native' && '$(1)/configure' \
        --prefix='$(PREFIX)' \
        --program-prefix='$(TARGET)-' \
        --disable-nls \
        --disable-python
    $(MAKE) -C '$(1).native' -j '$(JOBS)' install

    # yasm is always static
    cd '$(1)' && '$(1)/configure' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-nls
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
