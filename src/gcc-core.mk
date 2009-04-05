# GCC core

PKG             := gcc-core
$(PKG)_VERSION  := 4.3.3
$(PKG)_CHECKSUM := b907061e5788d7060bfb94396152ba9fc0786f91
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-core-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://gcc.gnu.org/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/tdm-gcc/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=200665&package_id=238462' | \
    grep 'gcc-core-' | \
    $(SED) -n 's,.*gcc-core-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef
