# This file is part of MXE.
# See index.html for further information.

PKG             := libdvdnav
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.0.1
$(PKG)_CHECKSUM := 9c234fc1a11f760c90cc278b702b1e41fc418b7e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
# Later releases seem to be hosted on VideoLAN's server
# $(PKG)_URL      := https://dvdnav.mplayerhq.hu/releases/$($(PKG)_FILE)
$(PKG)_URL      := http://download.videolan.org/pub/videolan/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libdvdread

# $(PKG)_UPDATE    = $(call MXE_GET_GITHUB_SHA, mirror/libdvdnav, master)

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://download.videolan.org/pub/videolan/libdvdnav/' | \
    $(SED) -n 's,.*href="\([0-9][^<]*\)/".*,\1,p' | \
    grep -v 'alpha\|beta\|rc' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' LDFLAGS=-no-undefined
    $(MAKE) -C '$(1)' -j 1 install LDFLAGS=-no-undefined
endef
