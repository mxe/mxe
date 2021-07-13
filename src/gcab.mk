# This file is part of MXE.
# See index.html for further information.

PKG             := gcab
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.4
$(PKG)_CHECKSUM := d81dfe35125e611e3a94c0d4def37ebf62b9187c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/$(PKG)/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := glib zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.gnome.org/browse/$(PKG)/refs/tags' | \
    $(SED) -n "s,.*tag/?id=\([0-9]\+\.[0-9]*[02468]\.[^']*\).*,\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/.build'
    cd '$(1)/.build' && '$(1)/configure' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --enable-static

    $(MAKE) -C '$(1)/.build' -j '$(JOBS)'
    $(MAKE) -C '$(1)/.build' -j 1 install
endef
