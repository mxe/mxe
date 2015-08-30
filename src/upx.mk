# This file is part of MXE.
# See index.html for further information.

PKG             := upx
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.91
$(PKG)_CHECKSUM := 527ce757429841f51675352b1f9f6fc8ad97b18002080d7bf8672c466d8c6a3c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)-src
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION)-src.tar.bz2
$(PKG)_URL      := http://upx.sourceforge.net/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc ucl zlib lzma

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://upx.sourceforge.net/' | \
    $(SED) -n 's,.*upx-\([0-9][^"]*\)\-src.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(call PREPARE_PKG_SOURCE,ucl,$(1))
    mkdir '$(1)/lzma'
    $(call PREPARE_PKG_SOURCE,lzma,$(1)/lzma)
    UPX_UCLDIR='$(1)/$(ucl_SUBDIR)' \
        UPX_LZMADIR='$(1)/lzma' \
        UPX_LZMA_VERSION=0x$(subst .,,$(lzma_VERSION)) \
        $(MAKE) -C '$(1)' -j '$(JOBS)' all \
        'CXX=$(TARGET)-g++' \
        'CC=$(TARGET)-gcc' \
        'LD=$(TARGET)-ld' \
        'AR=$(TARGET)-ar' \
        'PKG_CONFIG=$(TARGET)-pkg-config' \
        'exeext=.exe'
    cp '$(1)/src/upx.exe' '$(PREFIX)/$(TARGET)/bin/'
endef
