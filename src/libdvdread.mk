# This file is part of MXE.
# See index.html for further information.

PKG             := libdvdread
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.0.0
$(PKG)_CHECKSUM := f1fadbf19fd8d3a9a63ff610ec8ce9021ebc6947
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
# Later releases seem to be hosted on VideoLAN's server
# $(PKG)_URL      := https://dvdnav.mplayerhq.hu/releases/$($(PKG)_FILE)
$(PKG)_URL      := http://download.videolan.org/pub/videolan/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
# libdvdread supports libdvdcss either by dynamic loading (dlfcn-win32) or
# directly linking to libdvdcss. We directly links to the library here.
$(PKG)_DEPS     := gcc libdvdcss

$(PKG)_UPDATE_GIT = $(call MXE_GET_GITHUB_SHA, mirror/libdvdread, master)

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://download.videolan.org/pub/videolan/libdvdread/' | \
    $(SED) -n 's,.*href="\([0-9][^<]*\)/".*,\1,p' | \
    grep -v 'alpha\|beta\|rc' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-libdvdcss \
        --disable-apidoc
    $(MAKE) -C '$(1)' -j '$(JOBS)' LDFLAGS=-no-undefined
    $(MAKE) -C '$(1)' -j 1 install LDFLAGS=-no-undefined
endef
