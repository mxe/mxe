# zlib

PKG             := zlib
$(PKG)_VERSION  := 1.2.3
$(PKG)_CHECKSUM := 967e280f284d02284b0cd8872a8e2e04bfdc7283
$(PKG)_SUBDIR   := zlib-$($(PKG)_VERSION)
$(PKG)_FILE     := zlib-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.zlib.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/libpng/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/libpng/files/zlib/) | \
    $(SED) -n 's,.*zlib-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && CC='$(TARGET)-gcc' RANLIB='$(TARGET)-ranlib' ./configure \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
