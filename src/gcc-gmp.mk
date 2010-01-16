# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

# GMP for GCC
PKG             := gcc-gmp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.3.0
$(PKG)_CHECKSUM := 86dbd8a6b2fbb4c75760a80009227c9a11b801a9
$(PKG)_SUBDIR   := gmp-$($(PKG)_VERSION)
$(PKG)_FILE     := gmp-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.gmplib.org/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/tdm-gcc/Sources/Vanilla Sources/gmp-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/tdm-gcc/files/Sources/) | \
    $(SED) -n 's,.*gmp-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef
