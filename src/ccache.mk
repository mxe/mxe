# This file is part of MXE.
# See index.html for further information.

PKG             := ccache
$(PKG)_VERSION  := 3.1.9
$(PKG)_CHECKSUM := 1002d869cc87d1fc2f05b5d623abb41f342f577e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://samba.org/ftp/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ccache.samba.org/download.html' | \
    $(SED) -n "s,.*<a href='http://samba.org/ftp/ccache/ccache-\([0-9.]*\)'>.*,\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --build='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' 
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
