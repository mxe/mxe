# freetype
# http://freetype.sourceforge.net/

PKG            := freetype
$(PKG)_VERSION := 2.3.7
$(PKG)_SUBDIR  := freetype-$($(PKG)_VERSION)
$(PKG)_FILE    := freetype-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL     := http://$(SOURCEFORGE_MIRROR)/freetype/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=3157&package_id=3121' | \
    grep 'freetype-' | \
    $(SED) -n 's,.*freetype-\([2-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && GNUMAKE=$(MAKE) ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
