# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := fftw
$(PKG)_WEBSITE  := http://www.fftw.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.3.10
$(PKG)_CHECKSUM := 56c932549852cddcfafdab3820b0200c7742675be92179e59e6215b340e26467
$(PKG)_SUBDIR   := fftw-$($(PKG)_VERSION)
$(PKG)_FILE     := fftw-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.fftw.org/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.fftw.org/download.html' | \
    $(SED) -n 's,.*fftw-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v alpha | \
    grep -v beta | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-threads \
        --with-combined-threads
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-threads \
        --with-combined-threads \
        --enable-long-double
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-threads \
        --with-combined-threads \
        --enable-float
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
