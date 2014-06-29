# This file is part of MXE.
# See index.html for further information.

PKG             := libdvdnav
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := d0449a9
$(PKG)_CHECKSUM := ca5f7ef018a428af8f558cbc23af750cf6b322fc
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

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/mirror/libdvdnav/commits/master' | \
    $(SED) -n 's#.*<span class="sha">\([^<]\{7\}\)[^<]\{3\}<.*#\1#p' | \
    head -1
endef

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
