# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := zziplib
$(PKG)_WEBSITE  := https://github.com/gdraheim/zziplib
$(PKG)_DESCR    := ZZIPlib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.13.69
$(PKG)_CHECKSUM := 846246d7cdeee405d8d21e2922c6e97f55f24ecbe3b6dcf5778073a88f120544
$(PKG)_GH_CONF  := gdraheim/zziplib/tags,v
$(PKG)_DEPS     := cc zlib

define $(PKG)_BUILD
    # don't build and install docs
    (echo '# DISABLED'; echo 'all:'; echo 'install:') > '$(1)/docs/Makefile.in'
    # mman-win32 is only a partial implementation
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        CFLAGS="-O -ggdb" \
        PKG_CONFIG='$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= LDFLAGS="-no-undefined"
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
