# This file is part of MXE.
# See index.html for further information.

PKG             := unrtf
$(PKG)_VERSION  := 0.21.9
$(PKG)_CHECKSUM := 22a37826f96d754e335fb69f8036c068c00dd01ee9edd9461a36df0085fb8ddd
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.savannah.gnu.org/cgit/unrtf.git/refs/' | \
    $(SED) -n "s,.*<a href='/cgit/unrtf.git/tag/?id=v\([0-9.]*\)'>.*,\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./bootstrap
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        LIBS='-liconv -lws2_32'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
