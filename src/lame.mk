# This file is part of MXE.
# See index.html for further information.

PKG             := lame
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.99.5
$(PKG)_CHECKSUM := 03a0bfa85713adcc6b3383c12e2cc68a9cfbf4c4
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://lame.cvs.sourceforge.net/viewvc/lame/lame/' | \
    grep RELEASE_ | \
    $(SED) -n 's,.*RELEASE__\([0-9_][^<]*\)<.*,\1,p' | \
    tr '_' '.' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -i && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-frontend
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
