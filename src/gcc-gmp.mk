# This file is part of MXE.
# See index.html for further information.

PKG             := gcc-gmp
$(PKG)_IGNORE    = $(gmp_IGNORE)
$(PKG)_CHECKSUM  = $(gmp_CHECKSUM)
$(PKG)_SUBDIR    = $(gmp_SUBDIR)
$(PKG)_FILE      = $(gmp_FILE)
$(PKG)_URL       = $(gmp_URL)
$(PKG)_URL_2     = $(gmp_URL_2)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo $(gmp_VERSION)
endef

$(PKG)_BUILD_i686-static-mingw32    =
$(PKG)_BUILD_x86_64-static-mingw32  =
$(PKG)_BUILD_i686-dynamic-mingw32   =
$(PKG)_BUILD_x86_64-dynamic-mingw32 =
