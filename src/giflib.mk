# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := giflib
$(PKG)_WEBSITE  := https://sourceforge.net/projects/libungif/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.1.4
$(PKG)_CHECKSUM := df27ec3ff24671f80b29e6ab1c4971059c14ac3db95406884fc26574631ba8d5
$(PKG)_SUBDIR   := giflib-$($(PKG)_VERSION)
$(PKG)_FILE     := giflib-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/giflib/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/giflib/files/' | \
    grep '<a href.*giflib.*bz2/download' | \
    $(SED) -n 's,.*giflib-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        CPPFLAGS='-D_OPEN_BINARY'
    echo 'all:' > '$(1)/doc/Makefile'
    $(MAKE) -C '$(1)/lib' -j '$(JOBS)' install
endef
