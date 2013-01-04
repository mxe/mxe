# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# Mingw-w64
PKG             := mingw-w64
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 55f74b8b87c9b081844a1ba46e97b1db696f6e00
$(PKG)_SUBDIR   := $(PKG)-v$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-v$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(PKG)-release/$($(PKG)_FILE)
$(PKG)_URL_2    := http://downloads.sourceforge.net/project/$(PKG)/$(PKG)/$(PKG)-release/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
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
        --prefix='$(PREFIX)' \
        --enable-sdk=all
    $(MAKE) -C '$(1).headers-build' install
endef

$(PKG)_BUILD_x86_64-w64-mingw32 = $($(PKG)_BUILD_mingw-w64)
$(PKG)_BUILD_i686-w64-mingw32   = $($(PKG)_BUILD_mingw-w64)
