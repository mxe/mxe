# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# Mingw-w64
PKG             := mingw-w64
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 700c3d0517e65141f9719d38418549205bd69cef
$(PKG)_SUBDIR   := $(PKG)-v$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-v$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://sourceforge.net/projects/$(PKG)/files/$(PKG)/$(PKG)-release/$($(PKG)_FILE)/download
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package mingw-w64.' >&2;
    echo $(mingw-w64_VERSION)
endef

$(PKG)_BUILD_i686-static-mingw32    =
$(PKG)_BUILD_x86_64-static-mingw32  =
$(PKG)_BUILD_i686-dynamic-mingw32   =
$(PKG)_BUILD_x86_64-dynamic-mingw32 =
