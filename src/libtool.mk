# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GNU Libtool
PKG             := libtool
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4
$(PKG)_CHECKSUM := 149e9d7a993b643d13149a94d07bbca1085e601c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.gnu.org/software/$(PKG)/
$(PKG)_URL      := http://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://ftp.gnu.org/gnu/libtool/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="libtool-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)/libltdl' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --enable-ltdl-install
    $(MAKE) -C '$(1)/libltdl' -j '$(JOBS)'
    $(MAKE) -C '$(1)/libltdl' -j 1 install
endef
