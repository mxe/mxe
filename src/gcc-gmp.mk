# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GMP for GCC
PKG             := gcc-gmp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.3.0
$(PKG)_CHECKSUM := 86dbd8a6b2fbb4c75760a80009227c9a11b801a9
$(PKG)_SUBDIR   := gmp-$($(PKG)_VERSION)
$(PKG)_FILE     := gmp-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.gmplib.org/
$(PKG)_URL      := ftp://ftp.gmplib.org/pub/$($(PKG)_SUBDIR)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    wget -q -O- 'http://www.gmplib.org/' | \
    grep '<a href="' | \
    $(SED) -n 's,.*gmp-\([0-9][^>]*\)\.tar\.bz2.*,\1,p' | \
    grep -v '^4\.' | \
    head -1
endef
