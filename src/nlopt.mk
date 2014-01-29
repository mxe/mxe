# This file is part of MXE.
# See index.html for further information.

PKG             := nlopt
$(PKG)_VERSION  := 2.4.1
$(PKG)_CHECKSUM := 181181a3f7dd052e0740771994eb107bd59886ad
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ab-initio.mit.edu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ab-initio.mit.edu/wiki/index.php/NLopt_release_notes' | \
    $(SED) -n 's,.*<a href="#NLopt_\([0-9.]*\)">.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --enable-shared \
        --with-cxx \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
