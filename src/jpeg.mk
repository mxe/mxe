# jpeg

PKG             := jpeg
$(PKG)_VERSION  := 6b
$(PKG)_CHECKSUM := 7079f0d6c42fad0cfba382cf6ad322add1ace8f9
$(PKG)_SUBDIR   := jpeg-$($(PKG)_VERSION)
$(PKG)_FILE     := libjpeg6b_$($(PKG)_VERSION).orig.tar.gz
$(PKG)_WEBSITE  := http://www.ijg.org/
$(PKG)_URL      := http://ftp.debian.org/debian/pool/main/libj/libjpeg6b/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://packages.debian.org/unstable/source/libjpeg6b' | \
    $(SED) -n 's,.*libjpeg6b_\([0-9][^>]*\)\.orig\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        CC='$(TARGET)-gcc' RANLIB='$(TARGET)-ranlib' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install-lib
endef
