# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# Mingw-w64
PKG             := mingw-w64
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := bdbe8e33c630b82c14e4280e8bcfb8dc4b247f18
$(PKG)_SUBDIR   := $(PKG)-v$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-v$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(PKG)-release/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/' | \
    $(SED) -n 's,.*mingw-w64-v\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v [a-zA-Z] | \
    sort | \
    tail -1
endef

$(PKG)_BUILD_i686-static-mingw32    =
$(PKG)_BUILD_x86_64-static-mingw32  =
$(PKG)_BUILD_i686-dynamic-mingw32   =
$(PKG)_BUILD_x86_64-dynamic-mingw32 =
