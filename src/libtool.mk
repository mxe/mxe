# This file is part of MXE.
# See index.html for further information.

PKG             := libtool
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.4
$(PKG)_CHECKSUM := 159d4e20c201f929e3562536d3ae6b5e605403fa4bb4e72ef197a4e162c3fedf
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/libtool/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="libtool-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef
