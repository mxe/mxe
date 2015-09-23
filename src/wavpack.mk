# This file is part of MXE.
# See index.html for further information.

PKG             := wavpack
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.75.0
$(PKG)_CHECKSUM := c63e5c2106749dc6b2fb4302f2260f4803a93dd6cadf337764920dc836e3af2e
$(PKG)_SUBDIR   := wavpack-$($(PKG)_VERSION)
$(PKG)_FILE     := wavpack-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.wavpack.com/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.wavpack.com/downloads.html' | \
    grep '<a href="wavpack-.*\.tar\.bz2">' | \
    head -n 1 | \
    $(SED) -e 's/^.*<a href="wavpack-\([0-9.]*\)\.tar\.bz2">.*$$/\1/'
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
         $(MXE_CONFIGURE_OPTS) \
        --without-iconv \
        CFLAGS="-DWIN32"
    $(MAKE) -C '$(1)' -j '$(JOBS)' SUBDIRS="src include"
    $(MAKE) -C '$(1)' -j 1 install SUBDIRS="src include"
endef
