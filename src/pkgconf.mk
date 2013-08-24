# This file is part of MXE.
# See index.html for further information.

PKG             := pkgconf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 36827a3
$(PKG)_CHECKSUM := 51b6f1a5630414c4a76fca34d4029ea855644071
$(PKG)_SUBDIR   := $(PKG)-$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://github.com/$(PKG)/$(PKG)/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/pkgconf/pkgconf/commits/master' | \
    $(SED) -n 's#.*<span class="sha">\([^<]\{7\}\)[^<]\{3\}<.*#\1#p' | \
    head -1
endef

define $(PKG)_BUILD_NATIVE
    cd '$(1)' && ./autogen.sh
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
    ln -sf '$(PREFIX)/bin/pkgconf' '$(PREFIX)/bin/pkg-config'
endef
