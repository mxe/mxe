# libpng

PKG            := libpng
$(PKG)_VERSION := 1.2.35
$(PKG)_SUBDIR  := libpng-$($(PKG)_VERSION)
$(PKG)_FILE    := libpng-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE := http://www.libpng.org/
$(PKG)_URL     := http://$(SOURCEFORGE_MIRROR)/libpng/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=5624' | \
    grep 'package_id=5683&amp;release_id=' | \
    $(SED) -n 's,.*>\([0-9][^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
