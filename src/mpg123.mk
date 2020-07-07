# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mpg123
$(PKG)_WEBSITE  := https://www.mpg123.de/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.26.2
$(PKG)_CHECKSUM := 00f7bf7ea64fcec2c9d07751d6ad8849343ee09c282ea3b0d5dd486e886e2ff3
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
