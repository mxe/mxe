# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libtool
$(PKG)_WEBSITE  := https://www.gnu.org/software/libtool/
$(PKG)_DESCR    := GNU Libtool
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.4
$(PKG)_CHECKSUM := 159d4e20c201f929e3562536d3ae6b5e605403fa4bb4e72ef197a4e162c3fedf
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/libtool/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="libtool-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef
