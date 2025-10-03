# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libunistring
$(PKG)_WEBSITE  := https://www.gnu.org/software/libunistring/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4
$(PKG)_CHECKSUM := 708571fce9965e805fee08b410aa8e886d391a492c387f75abb7be0e195337f5
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/libunistring/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="libunistring-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-threads=win32
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
