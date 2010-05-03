# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# MPFR for GCC
PKG             := gcc-mpfr
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.1
$(PKG)_CHECKSUM := 1f965793526cafefb30cda64cebf3712cb75b488
$(PKG)_SUBDIR   := mpfr-$($(PKG)_VERSION)
$(PKG)_FILE     := mpfr-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.mpfr.org/
$(PKG)_URL      := http://www.mpfr.org/mpfr-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    wget -q --no-check-certificate -O- 'https://gforge.inria.fr/scm/viewvc.php/tags/?root=mpfr&sortby=date' | \
    $(SED) -n 's,.*<a name="\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef
