# This file is part of MXE.
# See index.html for further information.

PKG             := libdvdread
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.9.9
$(PKG)_CHECKSUM := 5536084fc7cd9a5d9fff9f91bfe7bf3e4cf3700e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://dvdnav.mplayerhq.hu/releases/$($(PKG)_FILE)
# $(PKG)_VERSION  := 7c74365
# $(PKG)_CHECKSUM := 99b12a4147064df85a7e5d6b0f00c00342c520a4
# $(PKG)_SUBDIR   := mirror-$(PKG)-$($(PKG)_VERSION)
# $(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
# $(PKG)_URL      := https://github.com/mirror/$(PKG)/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)

# libdvdread supports libdvdcss either by dynamic loading (dlfcn-win32) or
# directly linking to libdvdcss. We directly links to the library here.
$(PKG)_DEPS     := gcc libdvdcss

define $(PKG)_UPDATE_GIT
    $(WGET) -q -O- 'https://github.com/mirror/libdvdread/commits/master' | \
    $(SED) -n 's#.*<span class="sha">\([^<]\{7\}\)[^<]\{3\}<.*#\1#p' | \
    head -1
endef

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://dvdnav.mplayerhq.hu/releases/' | \
    $(SED) -n 's,.*libdvdread-\([0-9][^<]*\)\.tar.*,\1,p' | \
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
