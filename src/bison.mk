# This file is part of MXE.
# See index.html for further information.

PKG             := bison
$(PKG)_IGNORE   := 3%
$(PKG)_VERSION  := 2.7.1
$(PKG)_CHECKSUM := 00ab1b32d864622077c311e4f5420d4e2931fdc8
$(PKG)_SUBDIR   := bison-$($(PKG)_VERSION)
$(PKG)_FILE     := bison-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnu.org/pub/gnu/bison/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.gnu.org/pub/gnu/bison/$($(PKG)_FILE)
$(PKG)_DEPS     := flex

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/bison/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="bison-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD_$(BUILD)
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
