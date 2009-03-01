# MinGW binutils

PKG            := binutils
$(PKG)_VERSION := 2.19.1-mingw32
$(PKG)_SUBDIR  := binutils-$(firstword $(subst -, ,$($(PKG)_VERSION)))
$(PKG)_FILE    := binutils-$($(PKG)_VERSION)-src.tar.gz
$(PKG)_WEBSITE := http://mingw.sourceforge.net/
$(PKG)_URL     := http://$(SOURCEFORGE_MIRROR)/mingw/$($(PKG)_FILE)
$(PKG)_DEPS    := mingwrt w32api

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=2435&package_id=11290' | \
    $(SED) -n 's,.*binutils-\([0-9][^>]*\)-src\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --target='$(TARGET)' \
        --prefix='$(PREFIX)' \
        --with-gcc \
        --with-gnu-ld \
        --with-gnu-as \
        --disable-nls \
        --disable-shared
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
