# zlib
# http://www.zlib.net/

PKG            := zlib
$(PKG)_VERSION := 1.2.3
$(PKG)_SUBDIR  := zlib-$($(PKG)_VERSION)
$(PKG)_FILE    := zlib-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL     := http://$(SOURCEFORGE_MIRROR)/libpng/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=5624&package_id=14274' | \
    grep 'zlib-' | \
    $(SED) -n 's,.*zlib-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && CC='$(TARGET)-gcc' RANLIB='$(TARGET)-ranlib' ./configure \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
