# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# Mingw-w64
PKG             := mingw-w64
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := c660dcb6c7546731d35c33875583c9eef6fff0d9
$(PKG)_SUBDIR   := $(PKG)-v$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-v$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(PKG)-release/$($(PKG)_FILE)
$(PKG)_URL_2    := http://downloads.sourceforge.net/project/$(PKG)/$(PKG)/$(PKG)-release/$($(PKG)_FILE)

#redefine when using trunk
$(PKG)_SUBDIR   := mirror-$(PKG)-$($(PKG)_VERSION)/trunk
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/mirror/$(PKG)/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/mirror/$(PKG)/commits/master' | \
    $(SED) -n 's#.*<span class="sha">\([^<]\{7\}\)[^<]\{3\}<.*#\1#p' | \
    head -1
endef

define $(PKG)_UPDATE_RELEASE
    wget -q -O- 'http://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/' | \
    $(SED) -n 's,.*mingw-w64-v\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v [a-zA-Z] | \
    sort | \
    tail -1
endef

define $(PKG)_BUILD_mingw-w64
    mkdir '$(1).headers-build'
    cd '$(1).headers-build' && '$(1)/mingw-w64-headers/configure' \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-sdk=all
    $(MAKE) -C '$(1).headers-build' install
    ln -sf '$(PREFIX)/$(TARGET)' '$(PREFIX)/mingw'
endef

$(PKG)_BUILD_x86_64-w64-mingw32 = $($(PKG)_BUILD_mingw-w64)
$(PKG)_BUILD_i686-w64-mingw32   = $($(PKG)_BUILD_mingw-w64)
