# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := primesieve
$(PKG)_WEBSITE  := http://primesieve.org/
$(PKG)_DESCR    := Primesieve
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.5.0
$(PKG)_CHECKSUM := f0f818902967ce7c911c330c578a52ec62dbbd9b12a68b8d3a3bc79b601e52b0
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://dl.bintray.com/kimwalisch/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://primesieve.org/downloads/' | \
    $(SED) -n 's,.*primesieve-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v '\(linux\|mac\|win\)' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_CRUFT)

    $(TARGET)-g++ -s -std=c++0x -fopenmp -o '$(1)/examples/test-primesieve.exe' \
        '$(1)/examples/cpp/count_primes.cpp' \
        '-lprimesieve'
    $(INSTALL) -m755 '$(1)/examples/test-primesieve.exe' '$(PREFIX)/$(TARGET)/bin/'

endef
