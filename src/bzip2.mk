# bzip2

PKG            := bzip2
$(PKG)_VERSION := 1.0.5
$(PKG)_SUBDIR  := bzip2-$($(PKG)_VERSION)
$(PKG)_FILE    := bzip2-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE := http://www.bzip.org/
$(PKG)_URL     := http://www.bzip.org/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.bzip.org/downloads.html' | \
    grep 'bzip2-' | \
    $(SED) -n 's,.*bzip2-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,sys\\stat\.h,sys/stat.h,g' -i '$(1)/bzip2.c'
    $(MAKE) -C '$(1)' -j '$(JOBS)' libbz2.a \
        PREFIX='$(PREFIX)/$(TARGET)' \
        CC='$(TARGET)-gcc' \
        AR='$(TARGET)-ar' \
        RANLIB='$(TARGET)-ranlib'
    install -d '$(PREFIX)/$(TARGET)/lib'
    install -m664 '$(1)/libbz2.a' '$(PREFIX)/$(TARGET)/lib/'
    install -d '$(PREFIX)/$(TARGET)/include'
    install -m664 '$(1)/bzlib.h' '$(PREFIX)/$(TARGET)/include/'
endef
