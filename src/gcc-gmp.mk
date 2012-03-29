# This file is part of MXE.
# See doc/index.html for further information.

# GMP for GCC
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
