# This file is part of MXE.
# See index.html for further information.

PKG             := faad2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.7
$(PKG)_CHECKSUM := 80eaaa5cc576c35dd28863767b795c50cbcc0511
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/faac/$(PKG)-src/$(PKG)-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/faac/files/faad2-src/' | \
    $(SED) -n 's,.*faad2-\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' LDFLAGS='-no-undefined'
    $(MAKE) -C '$(1)' -j 1 install LDFLAGS='-no-undefined'
endef
