# This file is part of MXE.
# See index.html for further information.

PKG             := autoconf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.69
$(PKG)_CHECKSUM := e891c3193029775e83e0534ac0ee0c4c711f6d23
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnu.org/pub/gnu/autoconf/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.gnu.org/pub/gnu/autoconf/$($(PKG)_FILE)
$(PKG)_DEPS     := m4

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/autoconf/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="autoconf-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD_$(BUILD)
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
