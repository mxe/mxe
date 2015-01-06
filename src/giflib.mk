# This file is part of MXE.
# See index.html for further information.

PKG             := giflib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.0.5
$(PKG)_CHECKSUM := 926fecbcef1c5b1ca9d17257d15a197b8b35e405
$(PKG)_SUBDIR   := giflib-$($(PKG)_VERSION)
$(PKG)_FILE     := giflib-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/giflib/giflib-5.x/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/giflib/files/giflib-5.x/' | \
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