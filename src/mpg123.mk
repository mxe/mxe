# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mpg123
$(PKG)_WEBSITE  := https://www.mpg123.de/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.25.13
$(PKG)_CHECKSUM := 90306848359c793fd43b9906e52201df18775742dc3c81c06ab67a806509890a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/mpg123/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc sdl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/mpg123/files/mpg123/' | \
    $(SED) -n 's,.*/projects/.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-default-audio=win32 \
        --with-audio=win32,sdl,dummy \
        --enable-modules=no
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
