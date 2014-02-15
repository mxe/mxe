# This file is part of MXE.
# See index.html for further information.

PKG             := libsamplerate
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.8
$(PKG)_CHECKSUM := e5fe82c4786be2fa33ca6bd4897db4868347fe70
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.mega-nerd.com/SRC/$(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.mega-nerd.com/SRC/download.html' | \
    $(SED) -n 's,.*$(PKG)-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v 'alpha' | \
    grep -v 'beta' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j 1 install LDFLAGS='-no-undefined'
endef
