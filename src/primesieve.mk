# This file is part of MXE.
# See index.html for further information.

PKG             := primesieve
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.3
$(PKG)_CHECKSUM := dac89a72cc3789035149a7d2cfa48ef7d722fd8a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://dl.bintray.com/kimwalisch/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://dl.bintray.com/kimwalisch/primesieve/' | \
    $(SED) -n 's,.*primesieve-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= html_DATA=

    $(TARGET)-g++ -s -std=c++0x -o '$(1)/examples/test-primesieve.exe' \
        '$(1)/examples/count_primes.cpp' \
        '-lprimesieve'
    $(INSTALL) -m755 '$(1)/examples/test-primesieve.exe' '$(PREFIX)/$(TARGET)/bin/'

endef
