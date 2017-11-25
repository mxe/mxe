# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := zziplib
$(PKG)_WEBSITE  := https://zziplib.sourceforge.io/
$(PKG)_DESCR    := ZZIPlib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.13.62
$(PKG)_CHECKSUM := a1b8033f1a1fd6385f4820b01ee32d8eca818409235d22caf5119e0078c7525b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)$(word 2,$(subst ., ,$($(PKG)_VERSION)))/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/p/zziplib/svn/HEAD/tree/tags/' | \
    $(SED) -n 's,.*<a href="V_\([0-9][^"]*\)">.*,\1,p' | \
    tr '_' '.' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    # don't build and install docs
    (echo '# DISABLED'; echo 'all:'; echo 'install:') > '$(1)/docs/Makefile.in'
    # mman-win32 is only a partial implementation
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-mmap \
        CFLAGS="-O -ggdb" \
        PKG_CONFIG='$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= LDFLAGS="-no-undefined"
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
