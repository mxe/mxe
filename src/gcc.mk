# MinGW GCC
# http://mingw.sourceforge.net/

PKG            := gcc
$(PKG)_VERSION := 4.2.1-2
$(PKG)_SUBDIR  := gcc-$($(PKG)_VERSION)-src
$(PKG)_FILE    := gcc-$($(PKG)_VERSION)-src.tar.gz
$(PKG)_URL     := http://$(SOURCEFORGE_MIRROR)/mingw/$($(PKG)_FILE)
$(PKG)_DEPS    := mingwrt w32api binutils pkg_config

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=2435&package_id=241304' | \
    $(SED) -n 's,.*gcc-\([4-9][^>]*\)-src\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --target='$(TARGET)' \
        --prefix='$(PREFIX)' \
        --enable-languages='c,c++' \
        --enable-version-specific-runtime-libs \
        --with-gcc \
        --with-gnu-ld \
        --with-gnu-as \
        --disable-nls \
        --disable-shared \
        --without-x \
        --enable-threads=win32 \
        --disable-win32-registry \
        --enable-sjlj-exceptions
    $(MAKE) -C '$(1)' -j 1 all install
endef
