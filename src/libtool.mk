# This file is part of MXE.
# See index.html for further information.

PKG             := libtool
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.2
$(PKG)_CHECKSUM := 22b71a8b5ce3ad86e1094e7285981cae10e6ff88
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/libtool/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="libtool-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD_NATIVE
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(PREFIX)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef

define $(PKG)_BUILD
    cd '$(1)/libltdl' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --enable-ltdl-install
    $(MAKE) -C '$(1)/libltdl' -j '$(JOBS)'
    $(MAKE) -C '$(1)/libltdl' -j 1 install
endef
