# This file is part of MXE.
# See index.html for further information.

PKG             := libevent
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 3e6674772eb77de24908c6267c698146420ab699
$(PKG)_SUBDIR   := libevent-$($(PKG)_VERSION)-stable
$(PKG)_FILE     := libevent-$($(PKG)_VERSION)-stable.tar.gz
$(PKG)_URL      := https://github.com/downloads/$(PKG)/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://libevent.org/' | \
    grep 'libevent-' | \
    $(SED) -n 's,.*libevent-\([0-9][^>]*\)-stable\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
endef
