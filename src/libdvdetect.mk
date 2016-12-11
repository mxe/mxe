# mxe/src/libdvdetect.mk
# This file is part of MXE.
# See index.html for further information.

PKG             := libdvdetect
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 0.70.0
$(PKG)_CHECKSUM := c4c6f0d4bf4bc999c974ab93b4f5832d9b41e6703cc969656163d365b5a5d132
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://github.com/nschlia/libdvdetect/releases/download/RELEASE_0_70/libdvdetect-0.70.0.tar.bz2
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/nschlia/libdvdetect/tags/' | \
    grep '<a href="/nschlia/libdvdetect/archive/' | \
    $(SED) -n 's,.*href="/nschlia/libdvdetect/archive/RELEASE_\([0-9][^"]*\)\.tar.*,\1,p' | \
    sort | uniq | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && \
    	./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

$(PKG)_BUILD_i686-pc-mingw32    = $(subst @special-target@, x86-win32-gcc,    $($(PKG)_BUILD))
$(PKG)_BUILD_i686-w64-mingw32   = $(subst @special-target@, x86-win32-gcc,    $($(PKG)_BUILD))
$(PKG)_BUILD_x86_64-w64-mingw32 = $(subst @special-target@, x86_64-win64-gcc, $($(PKG)_BUILD))

