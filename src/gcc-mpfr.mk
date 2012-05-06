# This file is part of MXE.
# See index.html for further information.

PKG             := gcc-mpfr
$(PKG)_IGNORE    = $(mpfr_IGNORE)
$(PKG)_CHECKSUM  = $(mpfr_CHECKSUM)
$(PKG)_SUBDIR    = $(mpfr_SUBDIR)
$(PKG)_FILE      = $(mpfr_FILE)
$(PKG)_URL       = $(mpfr_URL)
$(PKG)_URL_2     = $(mpfr_URL_2)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo $(mpfr_VERSION)
endef

$(PKG)_BUILD_i686-static-mingw32    =
$(PKG)_BUILD_x86_64-static-mingw32  =
$(PKG)_BUILD_i686-dynamic-mingw32   =
$(PKG)_BUILD_x86_64-dynamic-mingw32 =
