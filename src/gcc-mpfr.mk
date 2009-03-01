# MPFR for GCC

PKG            := gcc-mpfr
$(PKG)_VERSION := 2.3.2
$(PKG)_SUBDIR  := mpfr-$($(PKG)_VERSION)
$(PKG)_FILE    := mpfr-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE := http://www.mpfr.org/
$(PKG)_URL     := http://$(SOURCEFORGE_MIRROR)/tdm-gcc/$($(PKG)_FILE)
$(PKG)_DEPS    :=

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=200665&package_id=238462' | \
    grep 'mpfr-' | \
    $(SED) -n 's,.*mpfr-\([2-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef
