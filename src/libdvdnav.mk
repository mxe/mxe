# This file is part of MXE.
# See index.html for further information.

PKG             := libdvdnav
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := b945868
$(PKG)_CHECKSUM := 5d55e5f2c1d9872742b6e2907722097c62bf40d6
$(PKG)_SUBDIR   := mirror-$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/mirror/$(PKG)/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
# Use Git snapshot for now because of its crash and assertion fixes
# Commented out until new version based on Git is released
# $(PKG)_VERSION  := 4.2.1
# $(PKG)_CHECKSUM :=
# $(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
# $(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
# $(PKG)_URL      := https://dvdnav.mplayerhq.hu/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libdvdread

$(PKG)_UPDATE    = $(call MXE_GET_GITHUB_SHA, mirror/libdvdnav, master)

define $(PKG)_UPDATE_RELEASE
    $(WGET) -q -O- 'https://dvdnav.mplayerhq.hu/releases/' | \
    $(SED) -n 's,.*libdvdnav-\([0-9][^<]*\)\.tar.*,\1,p' | \
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
