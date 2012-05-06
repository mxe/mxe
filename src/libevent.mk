# This file is part of MXE.
# See index.html for further information.

PKG             := libevent
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 28c109190345ce5469add8cf3f45c5dd57fe2a85
$(PKG)_SUBDIR   := libevent-$($(PKG)_VERSION)-stable
$(PKG)_FILE     := libevent-$($(PKG)_VERSION)-stable.tar.gz
$(PKG)_URL      := https://github.com/downloads/$(PKG)/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://libevent.org/' | \
    grep 'libevent-' | \
    $(SED) -n 's,.*libevent-\([0-9][^>]*\)-stable\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        $(LINK_STYLE) \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
endef

$(PKG)_BUILD_i686-static-mingw32   = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-static-mingw32 = $($(PKG)_BUILD)
