# This file is part of MXE.
# See index.html for further information.

PKG             := nettle
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1
$(PKG)_CHECKSUM := f6859d4ec88e70805590af9862b4b8c43a2d1fc7991df0a7a711b1e7ca9fc9d3
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.lysator.liu.se/~nisse/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gmp

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.lysator.liu.se/~nisse/archive/' | \
    $(SED) -n 's,.*nettle-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v 'pre' | \
    grep -v 'rc' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(if $(BUILD_STATIC),getopt.o getopt1.o,) SUBDIRS=
    $(MAKE) -C '$(1)' -j '$(JOBS)' install SUBDIRS=
endef
