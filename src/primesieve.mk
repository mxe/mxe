# This file is part of MXE.
# See index.html for further information.

PKG             := primesieve
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.4.1
$(PKG)_CHECKSUM := e6cb1eee915ff50dbd01ed9c6f13324cde16002c7ac49bf29feea07e0f348fc5
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://dl.bintray.com/kimwalisch/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libgomp

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
        '$(1)/examples/count_primes.cpp' \
        '-lprimesieve'
    $(INSTALL) -m755 '$(1)/examples/test-primesieve.exe' '$(PREFIX)/$(TARGET)/bin/'

endef
