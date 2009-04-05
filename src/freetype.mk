# freetype

PKG             := freetype
$(PKG)_VERSION  := 2.3.9
$(PKG)_CHECKSUM := db08969cb5053879ff9e973fe6dd2c52c7ea2d4e
$(PKG)_SUBDIR   := freetype-$($(PKG)_VERSION)
$(PKG)_FILE     := freetype-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://freetype.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/freetype/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=3157&package_id=3121' | \
    grep 'freetype-' | \
    $(SED) -n 's,.*freetype-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && GNUMAKE=$(MAKE) ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
