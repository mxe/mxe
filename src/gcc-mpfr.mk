# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# MPFR for GCC
PKG             := gcc-mpfr
$(PKG)_IGNORE    = $(mpfr_IGNORE)
$(PKG)_VERSION   = $(mpfr_VERSION)
$(PKG)_CHECKSUM  = $(mpfr_CHECKSUM)
$(PKG)_SUBDIR    = $(mpfr_SUBDIR)
$(PKG)_FILE      = $(mpfr_FILE)
$(PKG)_WEBSITE   = $(mpfr_WEBSITE)
$(PKG)_URL       = $(mpfr_URL)
$(PKG)_URL_2     = $(mpfr_URL_2)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo $(mpfr_VERSION)
endef
