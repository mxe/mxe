# This file is part of MXE.
# See index.html for further information.

PKG             := libevent
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 8a8813b2173b374cb64260245d7094fa81176854
$(PKG)_SUBDIR   := libevent-release-$($(PKG)_VERSION)-stable
$(PKG)_FILE     := release-$($(PKG)_VERSION)-stable.tar.gz
$(PKG)_URL      := https://github.com/$(PKG)/$(PKG)/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://libevent.org/' | \
    grep 'libevent-' | \
    $(SED) -n 's,.*libevent-\([0-9][^>]*\)-stable\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./autogen.sh && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
endef
