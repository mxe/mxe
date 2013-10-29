# This file is part of MXE.
# See index.html for further information.

PKG             := gcc-mpfr
$(PKG)_IGNORE    = $(mpfr_IGNORE)
$(PKG)_VERSION   = $(mpfr_VERSION)
$(PKG)_CHECKSUM  = $(mpfr_CHECKSUM)
$(PKG)_SUBDIR    = $(mpfr_SUBDIR)
$(PKG)_FILE      = $(mpfr_FILE)
$(PKG)_URL       = $(mpfr_URL)
$(PKG)_URL_2     = $(mpfr_URL_2)
$(PKG)_DEPS     := gcc-gmp

define $(PKG)_UPDATE
    echo $(mpfr_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(PREFIX)' \
        --disable-shared \
        --with-gmp='$(PREFIX)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef

$(PKG)_BUILD_$(BUILD) =
