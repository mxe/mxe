# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := nlopt
$(PKG)_WEBSITE  := https://ab-initio.mit.edu/wiki/index.php/NLopt
$(PKG)_DESCR    := NLopt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.2
$(PKG)_CHECKSUM := 8099633de9d71cbc06cd435da993eb424bbcdbded8f803cdaa9fb8c6e09c8e89
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ab-initio.mit.edu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ab-initio.mit.edu/wiki/index.php/NLopt' | \
    $(SED) -n 's,.*<a href=".*nlopt-\([0-9.]\+\).tar.gz".*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-cxx \
        --without-guile \
        --without-matlab \
        --without-octave \
        --without-python
    $(MAKE) -C '$(1)' -j '$(JOBS)' LDFLAGS='-no-undefined'
    $(MAKE) -C '$(1)' -j 1 install
endef
