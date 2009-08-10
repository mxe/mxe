# MinGW binutils

PKG             := binutils
$(PKG)_VERSION  := 2.19.1
$(PKG)_CHECKSUM := 7e930435c47991c4070b1c74b010350e4669011f
$(PKG)_SUBDIR   := binutils-$(firstword $(subst -, ,$($(PKG)_VERSION)))
$(PKG)_FILE     := binutils-$($(PKG)_VERSION)-src.tar.gz
$(PKG)_WEBSITE  := http://mingw.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/mingw/$($(PKG)_FILE)
$(PKG)_DEPS     := mingwrt w32api

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/mingw/files/GNU%20Binutils/) | \
    $(SED) -n 's,.*binutils-\([0-9][^>]*\)-src\.tar.*,\1,p' | \
    tail -1
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
