# This file is part of MXE.
# See index.html for further information.

PKG             := mpg123
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.19.0
$(PKG)_CHECKSUM := 835f8ae489b41ae69fa8c76a0b1e5ee5495ef0ae
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/mpg123/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sdl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/mpg123/files/mpg123/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
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
